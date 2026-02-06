#!/bin/bash
# Round 7: 10 jade-adjacent palettes (deep green, seafoam highlights)

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

# G5 Jade baseline was: 35 115 66 35 72 151 29 29
render "1. Jade (baseline)"                                35  115  66   35   72   151  29   29
render "2. Jade — brighter seafoam highlights"             35  122  66   35   79   158  29   29
render "3. Jade — warmer, hint of teal"                    36  115  67   36   73   152  30   30
render "4. Jade — cooler, blue-green shift"                30  109  60   30   72   116  23   23
render "5. Jade — lighter model, softer muted"             42  121  66   42   78   157  35   35
render "6. Jade — darker muted, high contrast highlights"  28  158  59   28   72   194  22   22
render "7. Jade — seafoam-forward, pale accents"           43  156  102  43   85   158  36   36
render "8. Jade — deep forest base, mint highlights"       29  115  65   29   71   150  22   22
render "9. Jade — aqua model, green-cyan blend"            37  121  66   37   79   152  30   30
render "10. Jade — muted sage base, bright seafoam pop"    65  157  101  65   78   194  29   29
