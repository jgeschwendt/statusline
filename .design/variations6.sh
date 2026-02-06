#!/bin/bash
# Round 6: 5 green + 5 purple palettes

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

# model, in, out, cached/total, cost/usable, time, ctx%, cwd
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
echo "  ${B}━━━ GREENS ━━━${R}"
echo

render "G1. Emerald — bright green primary, sage accents"       34  114  65   34   78   108  28   28
render "G2. Mint — light green primary, teal accents"           48  121  66   48   85   116  30   30
render "G3. Olive — muted yellow-green, warm green accents"     142 149  101  142  107  143  100  100
render "G4. Neon green — vivid lime, dark green contrast"       46  154  240  46   82   118  34   34
render "G5. Jade — deep green, seafoam highlights"              35  115  66   35   72   151  29   29

echo "  ${B}━━━ PURPLES ━━━${R}"
echo

render "P1. Lavender — soft violet primary, lilac accents"      141 183  103  141  146  189  98   98
render "P2. Deep purple — rich violet, magenta accents"         128 170  96   128  134  176  91   91
render "P3. Plum — warm purple, rose highlights"                133 175  96   133  168  182  97   97
render "P4. Amethyst — bright purple, periwinkle accents"       135 177  243  135  147  183  99   99
render "P5. Grape — dark purple, pale violet highlights"        92  141  60   92   134  147  55   55
