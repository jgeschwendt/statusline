#!/bin/bash
# Round 3: Dot separators + grouping, dim labels + bold colored values

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

# ── 1. Dots between items, spaces between groups ─────────────────────────
echo "  ${B}1. Dots within groups, double-space between groups${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n "  "; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; echo -n "  "; cb 70 "$COST"; echo
echo -n "  "; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cd 240 "$D"; echo -n " "; cb 59 "$CTXN"; echo -n "  "; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; echo
echo -n "  "; cb 26 "$CWD"; echo -n "  "; cb 178 "$GIT"; echo
hr

# ── 2. Dots everywhere, parens for groups ─────────────────────────────────
echo "  ${B}2. Dots everywhere, paren groups${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n " "; cd 240 "$D"; echo -n " "; cd 240 "("; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; cd 240 ")"; echo -n " "; cd 240 "$D"; echo -n " "; cb 70 "$COST"; echo
echo -n "  "; cd 240 "("; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cb 59 "$CTXN"; cd 240 ")"; echo -n " "; cd 240 "$D"; echo -n " "; cd 240 "("; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; cd 240 ")"; echo
echo -n "  "; cb 26 "$CWD"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$GIT"; echo
hr

# ── 3. Thin pipe between groups, dots within ──────────────────────────────
echo "  ${B}3. Thin pipe between groups, dots within${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n "  "; cd 238 "│"; echo -n "  "; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; echo -n "  "; cd 238 "│"; echo -n "  "; cb 70 "$COST"; echo
echo -n "  "; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cd 240 "$D"; echo -n " "; cb 59 "$CTXN"; echo -n "  "; cd 238 "│"; echo -n "  "; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; echo
echo -n "  "; cb 26 "$CWD"; echo -n "  "; cd 238 "│"; echo -n "  "; cb 178 "$GIT"; echo
hr

# ── 4. Bracket groups, dots within ────────────────────────────────────────
echo "  ${B}4. Bracket groups, dots within${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n "  "; cd 238 "["; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; cd 238 "]"; echo -n "  "; cb 70 "$COST"; echo
echo -n "  "; cd 238 "["; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cd 240 "$D"; echo -n " "; cb 59 "$CTXN"; cd 238 "]"; echo -n "  "; cd 238 "["; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; cd 238 "]"; echo
echo -n "  "; cb 26 "$CWD"; echo -n "  "; cb 178 "$GIT"; echo
hr

# ── 5. Unicode tokens + dots + pipe groups ────────────────────────────────
echo "  ${B}5. Unicode tokens + dots, pipe groups${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n "  "; cd 238 "│"; echo -n "  "; cd 245 "⇡"; cb 178 "$IN"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "⇣"; cb 59 "$OUT"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "↻"; cb 30 "$CACHED"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "∑"; cb 30 "$TOTAL"; echo -n "  "; cd 238 "│"; echo -n "  "; cb 70 "$COST"; echo
echo -n "  "; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cd 240 "$D"; echo -n " "; cb 59 "$CTXN"; echo -n "  "; cd 238 "│"; echo -n "  "; cd 245 "⏱"; cb 178 " $SESS"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "⏳"; cb 178 " $BLK"; echo
echo -n "  "; cb 26 "$CWD"; echo -n "  "; cd 238 "│"; echo -n "  "; cb 178 "$GIT"; echo
hr

# ── 6. All dots, value-first groups ───────────────────────────────────────
echo "  ${B}6. Value-first, all dots${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$IN"; cd 245 " in"; echo -n " "; cd 240 "$D"; echo -n " "; cb 59 "$OUT"; cd 245 " out"; echo -n " "; cd 240 "$D"; echo -n " "; cb 30 "$CACHED"; cd 245 " cached"; echo -n " "; cd 240 "$D"; echo -n " "; cb 30 "$TOTAL"; cd 245 " total"; echo -n " "; cd 240 "$D"; echo -n " "; cb 70 "$COST"; echo
echo -n "  "; cb 26 "$CTX"; cd 245 " ctx"; echo -n " "; cd 240 "$D"; echo -n " "; cb 70 "$CTXU"; cd 245 " usable"; echo -n " "; cd 240 "$D"; echo -n " "; cb 59 "$CTXN"; cd 245 " len"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$SESS"; cd 245 " session"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$BLK"; cd 245 " block"; echo
echo -n "  "; cb 26 "$CWD"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$GIT"; echo
hr

# ── 7. Two-line, dots + paren groups ──────────────────────────────────────
echo "  ${B}7. Two-line compact, dots + parens${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; echo -n " "; cd 240 "$D"; echo -n " "; cb 70 "$COST"; echo -n "  "; cd 240 "("; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cb 59 "$CTXN"; cd 240 ")"; echo
echo -n "  "; cb 26 "$CWD"; echo -n " "; cd 240 "$D"; echo -n " "; cb 178 "$GIT"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; echo
hr

# ── 8. Dots + em-dash group separators ────────────────────────────────────
echo "  ${B}8. Dots within, em-dash between groups${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n "  "; cd 238 "—"; echo -n "  "; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; echo -n "  "; cd 238 "—"; echo -n "  "; cb 70 "$COST"; echo
echo -n "  "; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cd 240 "$D"; echo -n " "; cb 59 "$CTXN"; echo -n "  "; cd 238 "—"; echo -n "  "; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; echo
echo -n "  "; cb 26 "$CWD"; echo -n "  "; cd 238 "—"; echo -n "  "; cb 178 "$GIT"; echo
hr

# ── 9. Angle bracket groups, dots within ──────────────────────────────────
echo "  ${B}9. Angle bracket groups, dots within${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n "  "; cd 238 "‹"; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; cd 238 "›"; echo -n "  "; cb 70 "$COST"; echo
echo -n "  "; cd 238 "‹"; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cd 240 "$D"; echo -n " "; cb 59 "$CTXN"; cd 238 "›"; echo -n "  "; cd 238 "‹"; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; cd 238 "›"; echo
echo -n "  "; cb 26 "$CWD"; echo -n "  "; cb 178 "$GIT"; echo
hr

# ── 10. Dots only, triple-space group gaps ────────────────────────────────
echo "  ${B}10. Pure dots, wide group gaps${R}"
echo
echo -n "  "; cb 30 "$MODEL"; echo -n "   "; cd 245 "in:"; cb 178 "$IN"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "out:"; cb 59 "$OUT"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "cached:"; cb 30 "$CACHED"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "total:"; cb 30 "$TOTAL"; echo -n "   "; cd 245 "cost:"; cb 70 "$COST"; echo
echo -n "  "; cd 245 "ctx:"; cb 26 "$CTX"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "u:"; cb 70 "$CTXU"; echo -n " "; cd 240 "$D"; echo -n " "; cb 59 "$CTXN"; echo -n "   "; cd 245 "session:"; cb 178 "$SESS"; echo -n " "; cd 240 "$D"; echo -n " "; cd 245 "block:"; cb 178 "$BLK"; echo
echo -n "  "; cd 245 "cwd:"; cb 26 "$CWD"; echo -n "   "; cb 178 "$GIT"; echo
hr
