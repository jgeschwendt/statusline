#!/bin/bash
# Render 10 statusline variations with sample data

R=$'\e[0m'
B=$'\e[1m'
D=$'\e[2m'
c()  { echo -n $'\e[38;5;'"$1"'m'"$2"$'\e[0m'; }
cb() { echo -n $'\e[1;38;5;'"$1"'m'"$2"$'\e[0m'; }
cd() { echo -n $'\e[2;38;5;'"$1"'m'"$2"$'\e[0m'; }

hr() { echo; echo -n "${D}"; for i in $(seq 1 72); do echo -n "─"; done; echo "${R}"; echo; }

# Sample data
MODEL="Opus 4.6"
IN="82" OUT="2.3k" CACHED="1.9M" TOTAL="1.9M" COST='$4.58'
CTX="22.5%" CTXU="28.1%" CTXN="45.0k" SESS="10m" BLK="0hr 47m"
CWD="~/.grove/code/jgeschwendt/statusline/.trunk"
GIT="(+0,-0)"

echo

# ── 1 ──
echo "  ${B}1. Dim labels, bright values${R}"
echo
echo -n "  "; cd 245 "$MODEL"; echo -n "  "; cd 245 "in:"; c 178 "$IN"; echo -n "  "; cd 245 "out:"; c 245 "$OUT"; echo -n "  "; cd 245 "cached:"; c 30 "$CACHED"; echo -n "  "; cd 245 "total:"; c 30 "$TOTAL"; echo -n "  "; cd 245 "cost:"; c 70 "$COST"; echo
echo -n "  "; cd 245 "ctx:"; c 26 "$CTX"; echo -n "  "; cd 245 "ctx(u):"; c 70 "$CTXU"; echo -n "  "; cd 245 "ctx:"; c 245 "$CTXN"; echo -n "  "; cd 245 "session:"; c 178 "$SESS"; echo -n "  "; cd 245 "block:"; c 178 "$BLK"; echo
echo -n "  "; cd 245 "cwd:"; c 26 "$CWD"; echo -n "  "; c 178 "$GIT"; echo
hr

# ── 2 ──
echo "  ${B}2. Pipe separators, two-tone${R}"
echo
echo -n "  "; c 75 "$MODEL"; echo -n " "; cd 240 "│"; echo -n " "; c 75 "in:$IN"; echo -n " "; cd 240 "│"; echo -n " "; c 75 "out:$OUT"; echo -n " "; cd 240 "│"; echo -n " "; c 75 "cached:$CACHED"; echo -n " "; cd 240 "│"; echo -n " "; c 75 "total:$TOTAL"; echo -n " "; cd 240 "│"; echo -n " "; c 114 "cost:$COST"; echo
echo -n "  "; c 75 "ctx:$CTX"; echo -n " "; cd 240 "│"; echo -n " "; c 114 "ctx(u):$CTXU"; echo -n " "; cd 240 "│"; echo -n " "; c 75 "ctx:$CTXN"; echo -n " "; cd 240 "│"; echo -n " "; c 75 "session:$SESS"; echo -n " "; cd 240 "│"; echo -n " "; c 75 "block:$BLK"; echo
echo -n "  "; c 75 "cwd:$CWD"; echo -n " "; cd 240 "│"; echo -n " "; c 75 "$GIT"; echo
hr

# ── 3 ──
echo "  ${B}3. Bold colored values, gray labels${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n "  "; c 244 "in:"; cb 178 "$IN"; echo -n "  "; c 244 "out:"; cb 244 "$OUT"; echo -n "  "; c 244 "cached:"; cb 30 "$CACHED"; echo -n "  "; c 244 "total:"; cb 30 "$TOTAL"; echo -n "  "; c 244 "cost:"; cb 70 "$COST"; echo
echo -n "  "; c 244 "ctx:"; cb 26 "$CTX"; echo -n "  "; c 244 "ctx(u):"; cb 70 "$CTXU"; echo -n "  "; c 244 "ctx:"; cb 244 "$CTXN"; echo -n "  "; c 244 "session:"; cb 178 "$SESS"; echo -n "  "; c 244 "block:"; cb 178 "$BLK"; echo
echo -n "  "; c 244 "cwd:"; cb 26 "$CWD"; echo -n "  "; cb 178 "$GIT"; echo
hr

# ── 4 ──
echo "  ${B}4. Dot separators, pastel palette${R}"
echo
echo -n "  "; c 117 "$MODEL"; echo -n " "; cd 240 "·"; echo -n " "; c 222 "in:$IN"; echo -n " "; cd 240 "·"; echo -n " "; c 249 "out:$OUT"; echo -n " "; cd 240 "·"; echo -n " "; c 117 "cached:$CACHED"; echo -n " "; cd 240 "·"; echo -n " "; c 117 "total:$TOTAL"; echo -n " "; cd 240 "·"; echo -n " "; c 150 "cost:$COST"; echo
echo -n "  "; c 111 "ctx:$CTX"; echo -n " "; cd 240 "·"; echo -n " "; c 150 "ctx(u):$CTXU"; echo -n " "; cd 240 "·"; echo -n " "; c 249 "ctx:$CTXN"; echo -n " "; cd 240 "·"; echo -n " "; c 222 "session:$SESS"; echo -n " "; cd 240 "·"; echo -n " "; c 222 "block:$BLK"; echo
echo -n "  "; c 111 "cwd:$CWD"; echo -n " "; cd 240 "·"; echo -n " "; c 222 "$GIT"; echo
hr

# ── 5 ──
echo "  ${B}5. Grouped with brackets${R}"
echo
echo -n "  "; c 30 "$MODEL"; echo -n "  "; cd 240 "["; c 178 "in:$IN"; echo -n " "; c 59 "out:$OUT"; echo -n " "; c 30 "cached:$CACHED"; echo -n " "; c 30 "total:$TOTAL"; cd 240 "]"; echo -n "  "; c 70 "cost:$COST"; echo
echo -n "  "; cd 240 "["; c 26 "ctx:$CTX"; echo -n " "; c 70 "ctx(u):$CTXU"; echo -n " "; c 59 "ctx:$CTXN"; cd 240 "]"; echo -n "  "; cd 240 "["; c 178 "session:$SESS"; echo -n " "; c 178 "block:$BLK"; cd 240 "]"; echo
echo -n "  "; c 26 "cwd:$CWD"; echo -n "  "; c 178 "$GIT"; echo
hr

# ── 6 ──
echo "  ${B}6. Unicode indicators, compact${R}"
echo
echo -n "  "; c 30 "$MODEL"; echo -n "  "; c 178 "↑$IN"; echo -n "  "; c 59 "↓$OUT"; echo -n "  "; c 30 "⟳$CACHED"; echo -n "  "; c 30 "Σ$TOTAL"; echo -n "  "; c 70 "$COST"; echo
echo -n "  "; c 26 "◧$CTX"; echo -n "  "; c 70 "◨$CTXU"; echo -n "  "; c 59 "≡$CTXN"; echo -n "  "; c 178 "◷$SESS"; echo -n "  "; c 178 "▮$BLK"; echo
echo -n "  "; c 26 "⌘ $CWD"; echo -n "  "; c 178 "±$GIT"; echo
hr

# ── 7 ──
echo "  ${B}7. Warm monochrome${R}"
echo
echo -n "  "; cb 179 "$MODEL"; echo -n "  "; c 179 "in:$IN"; echo -n "  "; c 137 "out:$OUT"; echo -n "  "; c 179 "cached:$CACHED"; echo -n "  "; c 179 "total:$TOTAL"; echo -n "  "; cb 214 "cost:$COST"; echo
echo -n "  "; c 173 "ctx:$CTX"; echo -n "  "; cb 214 "ctx(u):$CTXU"; echo -n "  "; c 137 "ctx:$CTXN"; echo -n "  "; c 179 "session:$SESS"; echo -n "  "; c 179 "block:$BLK"; echo
echo -n "  "; c 173 "cwd:$CWD"; echo -n "  "; c 179 "$GIT"; echo
hr

# ── 8 ──
echo "  ${B}8. High contrast, value-forward${R}"
echo
echo -n "  "; cb 255 "$MODEL"; echo -n "  "; cb 220 "$IN"; cd 245 "in"; echo -n "  "; cb 245 "$OUT"; cd 245 "out"; echo -n "  "; cb 51 "$CACHED"; cd 245 "cached"; echo -n "  "; cb 51 "$TOTAL"; cd 245 "total"; echo -n "  "; cb 82 "$COST"; echo
echo -n "  "; cb 39 "$CTX"; cd 245 "ctx"; echo -n "  "; cb 82 "$CTXU"; cd 245 "usable"; echo -n "  "; cb 245 "$CTXN"; cd 245 "len"; echo -n "  "; cb 220 "$SESS"; cd 245 "session"; echo -n "  "; cb 220 "$BLK"; cd 245 "block"; echo
echo -n "  "; cb 39 "$CWD"; echo -n "  "; cb 220 "$GIT"; echo
hr

# ── 9 ──
echo "  ${B}9. Slash separators, cool palette${R}"
echo
echo -n "  "; c 75 "$MODEL"; echo -n " "; cd 242 "/"; echo -n " "; c 110 "in:$IN"; echo -n " "; cd 242 "/"; echo -n " "; c 66 "out:$OUT"; echo -n " "; cd 242 "/"; echo -n " "; c 75 "cached:$CACHED"; echo -n " "; cd 242 "/"; echo -n " "; c 75 "total:$TOTAL"; echo -n " "; cd 242 "/"; echo -n " "; c 114 "cost:$COST"; echo
echo -n "  "; c 69 "ctx:$CTX"; echo -n " "; cd 242 "/"; echo -n " "; c 114 "ctx(u):$CTXU"; echo -n " "; cd 242 "/"; echo -n " "; c 66 "ctx:$CTXN"; echo -n " "; cd 242 "/"; echo -n " "; c 110 "session:$SESS"; echo -n " "; cd 242 "/"; echo -n " "; c 110 "block:$BLK"; echo
echo -n "  "; c 69 "cwd:$CWD"; echo -n " "; cd 242 "/"; echo -n " "; c 110 "$GIT"; echo
hr

# ── 10 ──
echo "  ${B}10. Two-line compact${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n "  "; c 178 "in:$IN"; echo -n " "; c 59 "out:$OUT"; echo -n " "; c 30 "cache:$CACHED"; echo -n " "; c 30 "tot:$TOTAL"; echo -n "  "; c 70 "$COST"; echo -n "  "; c 26 "ctx:$CTX"; echo -n " "; c 70 "u:$CTXU"; echo -n " "; c 59 "$CTXN"; echo
echo -n "  "; c 26 "$CWD"; echo -n "  "; c 178 "$GIT"; echo -n "  "; c 178 "⏱ $SESS"; echo -n " "; c 178 "▮ $BLK"; echo
hr
