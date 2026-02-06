use chrono::{DateTime, Timelike, Utc};
use serde::{Deserialize, Serialize};
use std::fs::{self, File};
use std::io::{self, BufRead, Read, Seek, SeekFrom};
use std::path::PathBuf;
use std::process::Command;

// ── ANSI colors (256-color) ──────────────────────────────────────────────────

const MODEL: u8 = 71;
const TOKEN: u8 = 150;
const MUTED: u8 = 101;
const COST: u8 = 78;
const TIME: u8 = 187;
const CWD_COLOR: u8 = 29;
const LABEL: u8 = 245;
const BRACKET: u8 = 238;
const DOT: u8 = 240;

// Pure foreground color — no bold/dim to avoid brightness flicker.
fn color(code: u8, text: &str) -> String {
    format!("\x1b[38;5;{}m{}", code, text)
}

/// Smooth gradient: jade(35) → green(71) → olive(107) → sage(143) →
/// gold(179) → orange(215) → coral(209) → salmon(203) → red(196) → crimson(160)
fn ctx_color(pct: f64) -> u8 {
    const STOPS: [(f64, u8); 10] = [
        (0.0, 35),
        (15.0, 71),
        (30.0, 107),
        (45.0, 143),
        (55.0, 179),
        (65.0, 215),
        (75.0, 209),
        (85.0, 203),
        (93.0, 196),
        (100.0, 160),
    ];
    if pct <= STOPS[0].0 {
        return STOPS[0].1;
    }
    for w in STOPS.windows(2) {
        if pct <= w[1].0 {
            let t = (pct - w[0].0) / (w[1].0 - w[0].0);
            return if t < 0.5 { w[0].1 } else { w[1].1 };
        }
    }
    STOPS[9].1
}

// ── Stdin JSON ───────────────────────────────────────────────────────────────

#[derive(Deserialize, Default)]
struct Input {
    session_id: Option<String>,
    model: Option<serde_json::Value>,
    cwd: Option<String>,
    transcript_path: Option<String>,
    cost: Option<Cost>,
}

#[derive(Deserialize, Default)]
struct Cost {
    total_cost_usd: Option<f64>,
    total_api_duration_ms: Option<u64>,
}

fn read_stdin() -> Input {
    let mut buf = String::new();
    if io::stdin().read_to_string(&mut buf).is_ok() {
        serde_json::from_str(&buf).unwrap_or_default()
    } else {
        Input::default()
    }
}

fn extract_model_name(value: &Option<serde_json::Value>) -> String {
    match value {
        Some(serde_json::Value::Object(map)) => map
            .get("display_name")
            .and_then(|v| v.as_str())
            .unwrap_or("Unknown")
            .to_string(),
        Some(serde_json::Value::String(s)) => s.clone(),
        _ => "Unknown".to_string(),
    }
}

fn extract_model_id(value: &Option<serde_json::Value>) -> String {
    match value {
        Some(serde_json::Value::Object(map)) => map
            .get("id")
            .and_then(|v| v.as_str())
            .unwrap_or("")
            .to_string(),
        Some(serde_json::Value::String(s)) => s.clone(),
        _ => String::new(),
    }
}

// ── Transcript JSONL ─────────────────────────────────────────────────────────

#[derive(Deserialize)]
struct TranscriptEntry {
    timestamp: Option<String>,
    #[serde(default)]
    #[serde(rename = "isSidechain")]
    is_sidechain: bool,
    #[serde(default)]
    #[serde(rename = "isApiErrorMessage")]
    is_api_error_message: bool,
    message: Option<Message>,
}

#[derive(Deserialize)]
struct Message {
    usage: Option<Usage>,
}

#[derive(Deserialize, Default, Clone)]
struct Usage {
    #[serde(default)]
    input_tokens: u64,
    #[serde(default)]
    output_tokens: u64,
    #[serde(default)]
    cache_creation_input_tokens: u64,
    #[serde(default)]
    cache_read_input_tokens: u64,
}

// ── Cache ────────────────────────────────────────────────────────────────────

#[derive(Serialize, Deserialize, Default)]
struct Cache {
    transcript_path: String,
    transcript_offset: u64,
    input_tokens: u64,
    output_tokens: u64,
    cached_tokens: u64,
    context_length: u64,
    most_recent_main_ts: Option<String>,
    most_recent_main_usage: Option<CachedUsage>,
    first_timestamp: Option<String>,
    last_timestamp: Option<String>,
    block_start_time: Option<String>,
    block_last_computed: Option<String>,
}

#[derive(Serialize, Deserialize, Default, Clone)]
struct CachedUsage {
    input_tokens: u64,
    cache_creation_input_tokens: u64,
    cache_read_input_tokens: u64,
}

fn cache_path(session_id: &str) -> PathBuf {
    PathBuf::from(format!("/tmp/statusline-{}.json", session_id))
}

fn load_cache(session_id: &str) -> Cache {
    let path = cache_path(session_id);
    fs::read_to_string(path)
        .ok()
        .and_then(|s| serde_json::from_str(&s).ok())
        .unwrap_or_default()
}

fn save_cache(session_id: &str, cache: &Cache) {
    let path = cache_path(session_id);
    if let Ok(json) = serde_json::to_string(cache) {
        let _ = fs::write(path, json);
    }
}

// ── Token Metrics ────────────────────────────────────────────────────────────

struct TokenMetrics {
    input_tokens: u64,
    output_tokens: u64,
    cached_tokens: u64,
    total_tokens: u64,
    context_length: u64,
}

fn parse_transcript(path: &str, cache: &mut Cache) -> TokenMetrics {
    let needs_cold_start = cache.transcript_path != path;

    if needs_cold_start {
        cache.transcript_path = path.to_string();
        cache.transcript_offset = 0;
        cache.input_tokens = 0;
        cache.output_tokens = 0;
        cache.cached_tokens = 0;
        cache.context_length = 0;
        cache.most_recent_main_ts = None;
        cache.most_recent_main_usage = None;
        cache.first_timestamp = None;
        cache.last_timestamp = None;
    }

    let mut file = match File::open(path) {
        Ok(f) => f,
        Err(_) => {
            return TokenMetrics {
                input_tokens: cache.input_tokens,
                output_tokens: cache.output_tokens,
                cached_tokens: cache.cached_tokens,
                total_tokens: cache.input_tokens + cache.output_tokens + cache.cached_tokens,
                context_length: cache.context_length,
            };
        }
    };

    // Seek to cached offset
    if cache.transcript_offset > 0 {
        if file.seek(SeekFrom::Start(cache.transcript_offset)).is_err() {
            // Seek failed — cold start
            cache.transcript_offset = 0;
            cache.input_tokens = 0;
            cache.output_tokens = 0;
            cache.cached_tokens = 0;
            cache.context_length = 0;
            cache.most_recent_main_ts = None;
            cache.most_recent_main_usage = None;
            cache.first_timestamp = None;
            cache.last_timestamp = None;
            let _ = file.seek(SeekFrom::Start(0));
        }
    }

    let reader = io::BufReader::new(&file);
    let mut bytes_read: u64 = 0;

    for line in reader.lines() {
        let line = match line {
            Ok(l) => l,
            Err(_) => continue,
        };
        bytes_read += line.len() as u64 + 1; // +1 for newline

        let entry: TranscriptEntry = match serde_json::from_str(&line) {
            Ok(e) => e,
            Err(_) => continue,
        };

        // Update first/last timestamps
        if let Some(ref ts) = entry.timestamp {
            if cache.first_timestamp.is_none() {
                cache.first_timestamp = Some(ts.clone());
            }
            cache.last_timestamp = Some(ts.clone());
        }

        // Accumulate tokens from usage
        if let Some(ref msg) = entry.message {
            if let Some(ref usage) = msg.usage {
                cache.input_tokens += usage.input_tokens;
                cache.output_tokens += usage.output_tokens;
                cache.cached_tokens +=
                    usage.cache_creation_input_tokens + usage.cache_read_input_tokens;

                // Track most recent main-chain entry for context_length
                if !entry.is_sidechain && !entry.is_api_error_message {
                    cache.most_recent_main_ts = entry.timestamp.clone();
                    cache.most_recent_main_usage = Some(CachedUsage {
                        input_tokens: usage.input_tokens,
                        cache_creation_input_tokens: usage.cache_creation_input_tokens,
                        cache_read_input_tokens: usage.cache_read_input_tokens,
                    });
                }
            }
        }
    }

    cache.transcript_offset += bytes_read;

    // Compute context_length from most recent main-chain entry
    if let Some(ref u) = cache.most_recent_main_usage {
        cache.context_length =
            u.input_tokens + u.cache_creation_input_tokens + u.cache_read_input_tokens;
    }

    TokenMetrics {
        input_tokens: cache.input_tokens,
        output_tokens: cache.output_tokens,
        cached_tokens: cache.cached_tokens,
        total_tokens: cache.input_tokens + cache.output_tokens + cache.cached_tokens,
        context_length: cache.context_length,
    }
}

// ── Session Duration ─────────────────────────────────────────────────────────

fn format_session_duration(first: &Option<String>, last: &Option<String>) -> String {
    let (Some(first_str), Some(last_str)) = (first, last) else {
        return "0m".to_string();
    };
    let (Ok(first_dt), Ok(last_dt)) = (
        first_str.parse::<DateTime<Utc>>(),
        last_str.parse::<DateTime<Utc>>(),
    ) else {
        return "0m".to_string();
    };

    let total_mins = (last_dt - first_dt).num_minutes().max(0) as u64;
    format_duration_mins(total_mins)
}

fn format_duration_mins(total_mins: u64) -> String {
    if total_mins < 1 {
        return "<1m".to_string();
    }
    let hours = total_mins / 60;
    let mins = total_mins % 60;
    match (hours, mins) {
        (0, m) => format!("{}m", m),
        (h, 0) => format!("{}hr", h),
        (h, m) => format!("{}hr {}m", h, m),
    }
}

// ── Block Timer ──────────────────────────────────────────────────────────────

fn compute_block_timer(cache: &mut Cache) -> String {
    let now = Utc::now();

    // TTL check: if computed <60s ago, return cached value
    if let Some(ref last_computed_str) = cache.block_last_computed {
        if let Ok(last_computed) = last_computed_str.parse::<DateTime<Utc>>() {
            if (now - last_computed).num_seconds() < 60 {
                if let Some(ref start_str) = cache.block_start_time {
                    if let Ok(start) = start_str.parse::<DateTime<Utc>>() {
                        let elapsed_mins = (now - start).num_minutes().max(0) as u64;
                        return format_duration_hm(elapsed_mins);
                    }
                }
                return "0hr 0m".to_string();
            }
        }
    }

    // Full recompute
    let block_start = compute_block_start(now);

    let result = match block_start {
        Some(start) => {
            cache.block_start_time = Some(start.to_rfc3339());
            let elapsed_mins = (now - start).num_minutes().max(0) as u64;
            format_duration_hm(elapsed_mins)
        }
        None => {
            cache.block_start_time = None;
            "0hr 0m".to_string()
        }
    };

    cache.block_last_computed = Some(now.to_rfc3339());
    result
}

fn format_duration_hm(total_mins: u64) -> String {
    let hours = total_mins / 60;
    let mins = total_mins % 60;
    format!("{}hr {}m", hours, mins)
}

fn compute_block_start(now: DateTime<Utc>) -> Option<DateTime<Utc>> {
    let claude_dir = dirs_claude();

    let pattern = format!("{}projects/**/*.jsonl", claude_dir);
    let mut files: Vec<PathBuf> = glob::glob(&pattern)
        .ok()?
        .filter_map(Result::ok)
        .collect();

    // Sort by mtime descending
    files.sort_by(|a, b| {
        let ma = fs::metadata(a).and_then(|m| m.modified()).ok();
        let mb = fs::metadata(b).and_then(|m| m.modified()).ok();
        mb.cmp(&ma)
    });

    // Collect timestamps with progressive lookback
    let lookback_hours = [10, 20, 48];
    let mut all_timestamps: Vec<DateTime<Utc>> = Vec::new();

    for &hours in &lookback_hours {
        let cutoff = now - chrono::Duration::hours(hours);
        let mut found_any_new = false;

        for file_path in &files {
            // Skip files older than cutoff
            if let Ok(meta) = fs::metadata(file_path) {
                if let Ok(modified) = meta.modified() {
                    let mtime: DateTime<Utc> = modified.into();
                    if mtime < cutoff {
                        continue;
                    }
                }
            }

            if let Ok(f) = File::open(file_path) {
                let reader = io::BufReader::new(f);
                for line in reader.lines() {
                    let line = match line {
                        Ok(l) => l,
                        Err(_) => continue,
                    };
                    let entry: TranscriptEntry = match serde_json::from_str(&line) {
                        Ok(e) => e,
                        Err(_) => continue,
                    };
                    if entry.is_sidechain {
                        continue;
                    }
                    // Only entries with real token usage
                    let has_usage = entry
                        .message
                        .as_ref()
                        .and_then(|m| m.usage.as_ref())
                        .map(|u| u.input_tokens > 0 || u.output_tokens > 0)
                        .unwrap_or(false);
                    if !has_usage {
                        continue;
                    }
                    if let Some(ref ts_str) = entry.timestamp {
                        if let Ok(ts) = ts_str.parse::<DateTime<Utc>>() {
                            if ts >= cutoff {
                                all_timestamps.push(ts);
                                found_any_new = true;
                            }
                        }
                    }
                }
            }
        }

        if found_any_new && !all_timestamps.is_empty() {
            // Try to find a block — if we find one, stop expanding
            if let Some(start) = find_block_start(&mut all_timestamps, now) {
                return Some(start);
            }
        }
    }

    // Final attempt with whatever we have
    if !all_timestamps.is_empty() {
        return find_block_start(&mut all_timestamps, now);
    }

    None
}

fn find_block_start(
    timestamps: &mut Vec<DateTime<Utc>>,
    now: DateTime<Utc>,
) -> Option<DateTime<Utc>> {
    timestamps.sort();
    timestamps.dedup();

    if timestamps.is_empty() {
        return None;
    }

    // Walk backwards from most recent to find continuous work start (5hr gap = break)
    let five_hours_secs = 5 * 3600;
    let mut continuous_start = *timestamps.last().unwrap();

    // Check if most recent activity is within 5hrs of now
    if (now - continuous_start).num_seconds() > five_hours_secs {
        return None;
    }

    for i in (0..timestamps.len() - 1).rev() {
        let gap = (timestamps[i + 1] - timestamps[i]).num_seconds();
        if gap > five_hours_secs {
            break;
        }
        continuous_start = timestamps[i];
    }

    // Floor to hour
    let floored = continuous_start
        .date_naive()
        .and_hms_opt(continuous_start.time().hour(), 0, 0)?;
    Some(DateTime::from_naive_utc_and_offset(floored, Utc))
}

fn dirs_claude() -> String {
    if let Ok(dir) = std::env::var("CLAUDE_CONFIG_DIR") {
        if dir.ends_with('/') {
            dir
        } else {
            format!("{}/", dir)
        }
    } else if let Ok(home) = std::env::var("HOME") {
        format!("{}/.claude/", home)
    } else {
        String::from("~/.claude/")
    }
}

// ── Git ──────────────────────────────────────────────────────────────────────

fn compute_git_changes(cwd: &str) -> (u32, u32) {
    let mut insertions: u32 = 0;
    let mut deletions: u32 = 0;

    for args in [&["diff", "--shortstat"][..], &["diff", "--cached", "--shortstat"][..]] {
        if let Ok(output) = Command::new("git")
            .args(args)
            .current_dir(cwd)
            .output()
        {
            if let Ok(text) = String::from_utf8(output.stdout) {
                insertions += parse_stat_number(&text, "insertion");
                deletions += parse_stat_number(&text, "deletion");
            }
        }
    }

    (insertions, deletions)
}

fn parse_stat_number(text: &str, keyword: &str) -> u32 {
    // Pattern: "N insertion" or "N deletion"
    for part in text.split(',') {
        let part = part.trim();
        if part.contains(keyword) {
            if let Some(num_str) = part.split_whitespace().next() {
                return num_str.parse().unwrap_or(0);
            }
        }
    }
    0
}

// ── Formatting ───────────────────────────────────────────────────────────────

fn format_tokens(count: u64) -> String {
    if count >= 1_000_000 {
        format!("{:.1}M", count as f64 / 1_000_000.0)
    } else if count >= 1_000 {
        format!("{:.1}k", count as f64 / 1_000.0)
    } else {
        count.to_string()
    }
}

fn format_cost(cost: f64) -> String {
    if cost >= 10.0 {
        format!("${:.0}", cost)
    } else {
        format!("${:.2}", cost)
    }
}


fn format_latency(ms: u64) -> String {
    if ms == 0 {
        return "0s".to_string();
    }
    let secs = ms / 1000;
    if secs < 60 {
        format!("{}s", secs)
    } else {
        let mins = secs / 60;
        let rem = secs % 60;
        if rem == 0 {
            format!("{}m", mins)
        } else {
            format!("{}m {}s", mins, rem)
        }
    }
}

fn nbsp(s: &str) -> String {
    s.replace(' ', "\u{00a0}")
}

// ── Terminal Width ──────────────────────────────────────────────────────────

fn get_terminal_width() -> Option<u16> {
    use std::os::unix::io::AsRawFd;

    let tty = File::open("/dev/tty").ok()?;
    let fd = tty.as_raw_fd();

    #[repr(C)]
    struct Winsize {
        ws_row: u16,
        ws_col: u16,
        ws_xpixel: u16,
        ws_ypixel: u16,
    }

    let mut ws = Winsize {
        ws_row: 0,
        ws_col: 0,
        ws_xpixel: 0,
        ws_ypixel: 0,
    };

    // TIOCGWINSZ = 0x5413 on Linux, 0x40087468 on macOS
    #[cfg(target_os = "macos")]
    const TIOCGWINSZ: libc_ioctl_t = 0x40087468;
    #[cfg(target_os = "linux")]
    const TIOCGWINSZ: libc_ioctl_t = 0x5413;

    #[cfg(target_os = "macos")]
    #[allow(non_camel_case_types)]
    type libc_ioctl_t = u64;
    #[cfg(target_os = "linux")]
    #[allow(non_camel_case_types)]
    type libc_ioctl_t = u64;

    let ret = libc_ioctl(fd, TIOCGWINSZ, &mut ws);
    if ret == 0 && ws.ws_col > 0 {
        Some(ws.ws_col)
    } else {
        None
    }
}

extern "C" {
    fn ioctl(fd: i32, request: u64, ...) -> i32;
}

// Wrapper to avoid name collision with std::io
fn libc_ioctl(fd: i32, request: u64, ws: &mut impl Sized) -> i32 {
    unsafe { ioctl(fd, request, ws as *mut _ as *mut std::ffi::c_void) }
}

// ── Main ─────────────────────────────────────────────────────────────────────

fn main() {
    let input = read_stdin();
    let session_id = input.session_id.as_deref().unwrap_or("default");
    let mut cache = load_cache(session_id);

    // Determine model context limits
    let model_id = extract_model_id(&input.model);
    let (max_tokens, usable_tokens): (u64, u64) = if model_id.contains("sonnet-4-5")
        || model_id.contains("sonnet-4.5")
    {
        (1_000_000, 800_000)
    } else {
        (200_000, 160_000)
    };

    // Parse transcript
    let metrics = match input.transcript_path {
        Some(ref path) => parse_transcript(path, &mut cache),
        None => TokenMetrics {
            input_tokens: 0,
            output_tokens: 0,
            cached_tokens: 0,
            total_tokens: 0,
            context_length: 0,
        },
    };

    // Session duration
    let session_dur = format_session_duration(&cache.first_timestamp, &cache.last_timestamp);

    // Block timer
    let block_dur = compute_block_timer(&mut cache);

    // Git changes
    let cwd = input.cwd.as_deref().unwrap_or(".");
    let (git_ins, git_del) = compute_git_changes(cwd);

    // Cost + latency
    let cost = input
        .cost
        .as_ref()
        .and_then(|c| c.total_cost_usd)
        .unwrap_or(0.0);
    let api_duration_ms = input
        .cost
        .as_ref()
        .and_then(|c| c.total_api_duration_ms)
        .unwrap_or(0);

    // Save cache
    save_cache(session_id, &cache);

    // ── Build lines ──────────────────────────────────────────────────────

    let model_name = extract_model_name(&input.model);
    let display_cwd = std::env::var("HOME")
        .ok()
        .and_then(|home| cwd.strip_prefix(&home).map(|rest| format!("~{}", rest)))
        .unwrap_or_else(|| cwd.to_string());

    let ctx_pct_val = if max_tokens > 0 {
        (metrics.context_length as f64 / max_tokens as f64 * 100.0).min(100.0)
    } else {
        0.0
    };
    let ctxu_pct_val = if usable_tokens > 0 {
        (metrics.context_length as f64 / usable_tokens as f64 * 100.0).min(100.0)
    } else {
        0.0
    };

    let latency = format_latency(api_duration_ms);

    let s = |t: &str| color(DOT, t);

    // Line 1: Model · $cost · [ctx:N% usable:N% total:Nk]
    let line1 = [
        color(MODEL, &model_name),
        s(" "),
        color(DOT, "·"),
        s(" "),
        color(COST, &format_cost(cost)),
        s(" "),
        color(DOT, "·"),
        s(" "),
        color(BRACKET, "["),
        color(LABEL, "ctx:"),
        color(ctx_color(ctx_pct_val), &format!("{:.1}%", ctx_pct_val)),
        s(" "),
        color(LABEL, "usable:"),
        color(ctx_color(ctxu_pct_val), &format!("{:.1}%", ctxu_pct_val)),
        s(" "),
        color(LABEL, "total:"),
        color(MUTED, &format_tokens(metrics.context_length)),
        color(BRACKET, "]"),
    ]
    .join("");

    // Line 2: [session:Nm(Ns) block:Nm] · [Nin + Nout + Ncached = N]
    let line2 = [
        color(BRACKET, "["),
        color(LABEL, "session:"),
        color(TIME, &session_dur),
        color(MUTED, &format!("({})", latency)),
        s(" "),
        color(LABEL, "block:"),
        color(TIME, &block_dur),
        color(BRACKET, "]"),
        s(" "),
        color(DOT, "·"),
        s(" "),
        color(BRACKET, "["),
        color(TOKEN, &format_tokens(metrics.input_tokens)),
        color(LABEL, "in"),
        s(" "),
        color(LABEL, "+"),
        s(" "),
        color(TOKEN, &format_tokens(metrics.output_tokens)),
        color(LABEL, "out"),
        s(" "),
        color(LABEL, "+"),
        s(" "),
        color(TOKEN, &format_tokens(metrics.cached_tokens)),
        color(LABEL, "cached"),
        s(" "),
        color(LABEL, "="),
        s(" "),
        color(TOKEN, &format_tokens(metrics.total_tokens)),
        color(BRACKET, "]"),
    ]
    .join("");

    // Line 3: [cwd] · (+N,-N)
    let line3 = [
        color(BRACKET, "["),
        color(CWD_COLOR, &display_cwd),
        color(BRACKET, "]"),
        s(" "),
        color(DOT, "·"),
        s(" "),
        color(TIME, &format!("(+{},-{})", git_ins, git_del)),
    ]
    .join("");

    // Line 4: context bar — used | remaining usable | unusable reserve
    let term_width = get_terminal_width().unwrap_or(80) as usize;
    let bar_width = term_width.saturating_sub(40); // margin for Claude Code chrome
    let usable_mark = if max_tokens > 0 {
        ((usable_tokens as f64 / max_tokens as f64) * bar_width as f64)
            .round()
            .min(bar_width as f64) as usize
    } else {
        bar_width
    };
    let filled = if max_tokens > 0 {
        ((metrics.context_length as f64 / max_tokens as f64) * bar_width as f64)
            .round()
            .min(bar_width as f64) as usize
    } else {
        0
    };
    // Build bar with bg colors: used | remaining usable | unusable reserve
    fn bg(code: u8) -> String {
        format!("\x1b[48;5;{}m", code)
    }
    let bar_color = ctx_color(ctx_pct_val);
    let mut line4 = String::new();
    for i in 0..bar_width {
        let zone_bg = if i < filled {
            bar_color
        } else if i < usable_mark {
            236
        } else {
            234
        };
        line4.push_str(&format!("{} ", bg(zone_bg)));
    }
    line4.push_str("\x1b[49m");

    // Output: \x1b[0m prefix overrides Claude Code's dim, \x1b[0m suffix cleanly ends
    println!("{}", nbsp(&format!("\x1b[0m{}\x1b[0m", line1)));
    println!("{}", nbsp(&format!("\x1b[0m{}\x1b[0m", line2)));
    println!("{}", nbsp(&format!("\x1b[0m{}\x1b[0m", line3)));
    print!("{}", nbsp(&format!("\x1b[0m{}\x1b[0m", line4)));
}
