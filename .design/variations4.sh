#!/bin/bash
# Round 4: Bracket groups with dots OUTSIDE (between groups)

R=$'\e[0m'
B=$'\e[1m'
c()  { echo -n $'\e[38;5;'"$1"'m'"$2"$'\e[0m'; }
cb() { echo -n $'\e[1;38;5;'"$1"'m'"$2"$'\e[0m'; }
cd() { echo -n $'\e[2;38;5;'"$1"'m'"$2"$'\e[0m'; }

hr() { echo; echo -n $'\e[2m'; for i in $(seq 1 72); do echo -n "─"; done; echo "${R}"; echo; }

MODEL="Opus 4.6"
IN="82" OUT="2.3k" CACHED="1.9M" TOTAL="1.9M" COST='$4.58'
CTX="22.5%" CTXU="28.1%" CTXN="45.0k" SESS="10m" BLK="0hr 47m"
CWD="~/.grove/code/jgeschwendt/statusline/.trunk"
GIT="(+0,-0)"
D="·"

echo

# ── 1. Standard brackets, dots outside ────────────────────────────────────
echo "  ${B}1. Standard brackets, dots between groups${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cb 70 "$COST"; echo
echo -n "  "; cd 238 "["; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cb 59 "$CTXN"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; cd 238 "]"; echo
echo -n "  "; cb 26 "$CWD"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$GIT"; echo
hr

# ── 2. No labels in token bracket ─────────────────────────────────────────
echo "  ${B}2. Labelless token bracket${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cb 178 "$IN"; echo -n " "; cb 59 "$OUT"; echo -n " "; cb 30 "$CACHED"; echo -n " "; cb 30 "$TOTAL"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cb 70 "$COST"; echo
echo -n "  "; cd 238 "["; cb 26 "$CTX"; echo -n " "; cb 70 "$CTXU"; echo -n " "; cb 59 "$CTXN"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cb 178 "$SESS"; echo -n " "; cb 178 "$BLK"; cd 238 "]"; echo
echo -n "  "; cb 26 "$CWD"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$GIT"; echo
hr

# ── 3. Brackets with colon separator inside ───────────────────────────────
echo "  ${B}3. Colon-separated inside brackets${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 238 ":"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 238 ":"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 238 ":"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cb 70 "$COST"; echo
echo -n "  "; cd 238 "["; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 238 ":"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cd 238 ":"; echo -n " "; cb 59 "$CTXN"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 238 ":"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; cd 238 "]"; echo
echo -n "  "; cb 26 "$CWD"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$GIT"; echo
hr

# ── 4. Tight brackets, value-first inside ─────────────────────────────────
echo "  ${B}4. Value-first inside brackets${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cb 178 "$IN"; cd 245 " in"; echo -n " "; cb 59 "$OUT"; cd 245 " out"; echo -n " "; cb 30 "$CACHED"; cd 245 " cached"; echo -n " "; cb 30 "$TOTAL"; cd 245 " total"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cb 70 "$COST"; echo
echo -n "  "; cd 238 "["; cb 26 "$CTX"; cd 245 " ctx"; echo -n " "; cb 70 "$CTXU"; cd 245 " u"; echo -n " "; cb 59 "$CTXN"; cd 245 " len"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cb 178 "$SESS"; cd 245 " session"; echo -n " "; cb 178 "$BLK"; cd 245 " block"; cd 238 "]"; echo
echo -n "  "; cb 26 "$CWD"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$GIT"; echo
hr

# ── 5. Unicode tokens inside brackets ─────────────────────────────────────
echo "  ${B}5. Unicode token icons inside brackets${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cd 245 "⇡"; cb 178 "$IN"; echo -n " "; cd 245 "⇣"; cb 59 "$OUT"; echo -n " "; cd 245 "↻"; cb 30 "$CACHED"; echo -n " "; cd 245 "∑"; cb 30 "$TOTAL"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cb 70 "$COST"; echo
echo -n "  "; cd 238 "["; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cb 59 "$CTXN"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cd 245 "⏱ "; cb 178 "$SESS"; echo -n " "; cd 245 "⏳ "; cb 178 "$BLK"; cd 238 "]"; echo
echo -n "  "; cb 26 "$CWD"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$GIT"; echo
hr

# ── 6. Thin brackets (single-char delimiters) ────────────────────────────
echo "  ${B}6. Thin bracket chars ⟨ ⟩${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "⟨"; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; cd 238 "⟩"; echo -n " "; cd 240 "$D"; echo -n " "; cb 70 "$COST"; echo
echo -n "  "; cd 238 "⟨"; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cb 59 "$CTXN"; cd 238 "⟩"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "⟨"; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; cd 238 "⟩"; echo
echo -n "  "; cb 26 "$CWD"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$GIT"; echo
hr

# ── 7. Double-dot separator ·· between groups ─────────────────────────────
echo "  ${B}7. Double-dot ·· between groups${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n " "; cd 240 "··"; echo -n " "; cd 238 "["; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; cd 238 "]"; echo -n " "; cd 240 "··"; echo -n " "; cb 70 "$COST"; echo
echo -n "  "; cd 238 "["; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cb 59 "$CTXN"; cd 238 "]"; echo -n " "; cd 240 "··"; echo -n " "; cd 238 "["; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; cd 238 "]"; echo
echo -n "  "; cb 26 "$CWD"; echo -n " "; cd 240 "··"; echo -n " "; cb 178 "$GIT"; echo
hr

# ── 8. Brackets + cost inside token group ─────────────────────────────────
echo "  ${B}8. Cost inside token group${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; echo -n " "; cd 245 "cost:"; cb 70 "$COST"; cd 238 "]"; echo
echo -n "  "; cd 238 "["; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cb 59 "$CTXN"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; cd 238 "]"; echo
echo -n "  "; cb 26 "$CWD"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$GIT"; echo
hr

# ── 9. Two-line with brackets + dots ──────────────────────────────────────
echo "  ${B}9. Two-line, brackets + dots${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cb 70 "$COST"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cb 59 "$CTXN"; cd 238 "]"; echo
echo -n "  "; cb 26 "$CWD"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$GIT"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; cd 238 "]"; echo
hr

# ── 10. Mixed: cwd also bracketed ────────────────────────────────────────
echo "  ${B}10. Everything bracketed${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cb 70 "$COST"; echo
echo -n "  "; cd 238 "["; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cb 59 "$CTXN"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cd 238 "["; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; cd 238 "]"; echo
echo -n "  "; cd 238 "["; cb 26 "$CWD"; cd 238 "]"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$GIT"; echo
hr
