#!/bin/bash
# Round 8: 10 sage-jade variations + ctx% color gradient demo

R=$'\e[0m'
B=$'\e[1m'
cb() { echo -n $'\e[1;38;5;'"$1"'m'"$2"$'\e[0m'; }
cd() { echo -n $'\e[2;38;5;'"$1"'m'"$2"$'\e[0m'; }

hr() { echo; echo -n $'\e[2m'; for i in $(seq 1 72); do echo -n "─"; done; echo "${R}"; echo; }

MODEL="Opus 4.6"
IN="82" OUT="2.3k" CACHED="1.9M" TOTAL="1.9M" COST='$4.58'
CTXN="45.0k" SESS="10m" BLK="0hr 47m"
CWD="~/.grove/code/jgeschwendt/statusline/.trunk"
GIT="(+0,-0)"

# Sage baseline was: 65 157 101 65 78 194 29 29
# model, in, out, cached/total, cost/usable, time, ctx%(unused here), cwd
render() {
    local name="$1" cM="$2" cI="$3" cO="$4" cC="$5" cG="$6" cT="$7" cCtx="$8" cCwd="$9"
    echo "  ${B}${name}${R}"
    echo
    echo -n "  "; cb $cM "$MODEL"; echo -n " "; cd 240 "·"; echo -n " "; cd 238 "["; cd 245 "in:"; cb $cI "$IN"; echo -n " "; cd 245 "out:"; cb $cO "$OUT"; echo -n " "; cd 245 "cached:"; cb $cC "$CACHED"; echo -n " "; cd 245 "total:"; cb $cC "$TOTAL"; cd 238 "]"; echo -n " "; cd 240 "·"; echo -n " "; cb $cG "$COST"; echo
    # ctx line with gradient demo: 22% green, 55% yellow, 85% red
    echo -n "  "; cd 238 "["; cd 245 "ctx:"; cb 71 "22.5%"; echo -n " "; cd 245 "u:"; cb $cG "28.1%"; echo -n " "; cb $cO "$CTXN"; cd 238 "]"; echo -n " "; cd 240 "·"; echo -n " "; cd 238 "["; cd 245 "session:"; cb $cT "$SESS"; echo -n " "; cd 245 "block:"; cb $cT "$BLK"; cd 238 "]"; echo
    echo -n "  "; cd 238 "["; cb $cCwd "$CWD"; cd 238 "]"; echo -n " "; cd 240 "·"; echo -n " "; cb $cT "$GIT"; echo
    hr
}

echo

render "1. Sage baseline"                                    65  157  101  65   78   194  29   29
render "2. Sage — slightly brighter model"                   71  157  101  71   78   194  29   29
render "3. Sage — warmer muted tones"                        65  150  101  65   78   187  29   29
render "4. Sage — cooler muted, blue-sage"                   65  157  102  65   72   194  23   23
render "5. Sage — deeper model, brighter in"                 59  158  101  59   78   194  29   29
render "6. Sage — lighter out, more contrast"                65  157  108  65   78   194  29   29
render "7. Sage — muted model, vivid highlights"             101 158  243  101  78   194  65   65
render "8. Sage — all slightly lifted"                       71  158  108  71   79   194  35   35
render "9. Sage — tighter range, subtle"                     65  151  101  65   72   187  29   29
render "10. Sage — darker base, max pop"                     59  194  243  59   78   194  23   23

echo
echo "  ${B}━━━ CTX% COLOR GRADIENT DEMO ━━━${R}"
echo
echo "  Using sage palette #1, showing ctx% at different levels:"
echo
# Show how ctx% changes color as it increases
echo -n "  "; cd 245 "ctx:"; cb 71 "10.2%"; echo -n "  "; cd 245 "ctx:"; cb 107 "25.0%"; echo -n "  "; cd 245 "ctx:"; cb 149 "40.0%"; echo -n "  "; cd 245 "ctx:"; cb 178 "55.0%"; echo -n "  "; cd 245 "ctx:"; cb 214 "70.0%"; echo -n "  "; cd 245 "ctx:"; cb 208 "80.0%"; echo -n "  "; cd 245 "ctx:"; cb 196 "90.0%"; echo -n "  "; cd 245 "ctx:"; cb 160 "100%"; echo
echo
echo "  Gradient: green(71) → olive(107) → yellow-green(149) → yellow(178) → orange(214) → red-orange(208) → red(196) → dark red(160)"
hr

echo "  Alternative gradient (smoother):"
echo
echo -n "  "; cd 245 "ctx:"; cb 35 "10%"; echo -n "  "; cd 245 "ctx:"; cb 71 "25%"; echo -n "  "; cd 245 "ctx:"; cb 107 "40%"; echo -n "  "; cd 245 "ctx:"; cb 143 "50%"; echo -n "  "; cd 245 "ctx:"; cb 179 "60%"; echo -n "  "; cd 245 "ctx:"; cb 215 "70%"; echo -n "  "; cd 245 "ctx:"; cb 209 "80%"; echo -n "  "; cd 245 "ctx:"; cb 203 "90%"; echo -n "  "; cd 245 "ctx:"; cb 196 "95%"; echo -n "  "; cd 245 "ctx:"; cb 160 "100%"; echo
echo
echo "  Gradient: jade(35) → green(71) → olive(107) → sage(143) → gold(179) → orange(215) → coral(209) → salmon(203) → red(196) → crimson(160)"
hr
