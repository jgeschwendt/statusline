#!/bin/bash
# Round 5: Style 10 (bracket groups, dots outside, dim labels, bold values)
# 10 color variations for the bold values — labels stay dim 245/238

R=$'\e[0m'
B=$'\e[1m'
cb() { echo -n $'\e[1;38;5;'"$1"'m'"$2"$'\e[0m'; }
cd() { echo -n $'\e[2;38;5;'"$1"'m'"$2"$'\e[0m'; }

hr() { echo; echo -n $'\e[2m'; for i in $(seq 1 72); do echo -n "─"; done; echo "${R}"; echo; }

MODEL="Opus 4.6"
IN="82" OUT="2.3k" CACHED="1.9M" TOTAL="1.9M" COST='$4.58'
CTX="22.5%" CTXU="28.1%" CTXN="45.0k" SESS="10m" BLK="0hr 47m"
CWD="~/.grove/code/jgeschwendt/statusline/.trunk"
GIT="(+0,-0)"

# Template function: takes 6 color codes (model, in, out, cached/total, cost/usable, time)
render() {
    local name="$1" cM="$2" cI="$3" cO="$4" cC="$5" cG="$6" cT="$7" cCtx="$8" cCwd="$9"
    echo "  ${B}${name}${R}"
    echo
    echo -n "  "; cb $cM "$MODEL"; echo -n " "; cd 240 "·"; echo -n " "; cd 238 "["; cd 245 "in:"; cb $cI "$IN"; echo -n " "; cd 245 "out:"; cb $cO "$OUT"; echo -n " "; cd 245 "cached:"; cb $cC "$CACHED"; echo -n " "; cd 245 "total:"; cb $cC "$TOTAL"; cd 238 "]"; echo -n " "; cd 240 "·"; echo -n " "; cb $cG "$COST"; echo
    echo -n "  "; cd 238 "["; cd 245 "ctx:"; cb $cCtx "$CTX"; echo -n " "; cd 245 "u:"; cb $cG "$CTXU"; echo -n " "; cb $cO "$CTXN"; cd 238 "]"; echo -n " "; cd 240 "·"; echo -n " "; cd 238 "["; cd 245 "session:"; cb $cT "$SESS"; echo -n " "; cd 245 "block:"; cb $cT "$BLK"; cd 238 "]"; echo
    echo -n "  "; cd 238 "["; cb $cCwd "$CWD"; cd 238 "]"; echo -n " "; cd 240 "·"; echo -n " "; cb $cT "$GIT"; echo
    hr
}

echo

# model, in, out, cached/total, cost/usable, time, ctx%, cwd
render "1. Original (cyan/yellow/gray/green/blue)"     30  178  59   30   70  178  26   26
render "2. Warm gold (amber/orange/tan)"                214 220  137  214  148  179  173  173
render "3. Cool ocean (teal/steel/slate)"               37  74   66   37   114  110  69   69
render "4. Neon (bright cyan/magenta/lime)"             51  207  243  51   82   220  39   39
render "5. Muted earth (olive/rust/sand)"               143 173  102  143  107  180  130  130
render "6. Purple haze (lavender/violet/mauve)"         141 177  103  141  114  183  99   99
render "7. Mono blue (all blues, varying intensity)"    75  111  67   75   114  110  69   69
render "8. Sunset (coral/peach/amber)"                  209 216  174  209  150  222  167  167
render "9. Forest (green/moss/sage)"                    71  150  65   71   114  108  29   29
render "10. Ice (white/silver/pale blue)"               159 195  249  159  158  253  117  117
