# Give each new terminal a distinct background color so different windows/tabs
# are easy to tell apart. A mix of dark and light shades; the foreground is
# chosen per color for contrast. Uses OSC 11/10 (supported by Apple Terminal,
# iTerm2, and most modern terminals).
if [[ -o interactive ]]; then
  __random_term_bg() {
    # Backgrounds spanning the full hue wheel so windows are easy to tell
    # apart. A mix of deep/dark and soft/light shades — the foreground is
    # chosen automatically per color (below) from its luminance, so both stay
    # readable. Each entry is "hexcolor:Name".
    local palette=(
      # --- dark backgrounds ---
      # reds / maroons
      "2e1216:Oxblood"
      "3a0d12:Wine"
      "40161a:Brick"
      # oranges / ambers / browns
      "3a1e0d:Burnt Umber"
      "2e1d0a:Molasses"
      "3d2a12:Cognac"
      # yellows / olives
      "2c2a0e:Olive Night"
      "33300f:Dark Chartreuse"
      # greens
      "0e2c14:Forest"
      "0a3320:Emerald Depths"
      "153a1a:Moss"
      "0d2e22:Pine"
      # teals / cyans
      "0a2e2e:Deep Teal"
      "0c3339:Petrol"
      "07333a:Abyss Cyan"
      # blues
      "0d1f3d:Navy"
      "112641:Deep Ocean"
      "0a2447:Cobalt"
      "011627:Night Owl"
      # indigos / violets
      "1c1442:Indigo"
      "251650:Blackcurrant"
      "1d1235:Midnight Violet"
      # purples / magentas
      "2c1240:Royal Purple"
      "36104a:Aubergine"
      "2e0f33:Plum"
      # pinks / roses
      "3a0f2c:Mulberry"
      "40122e:Boysenberry"
      # neutral anchors for contrast
      "1c1c1c:Charcoal"
      "0d1117:GitHub Dark"
      "202230:Slate"

      # --- light backgrounds ---
      # warm neutrals / papers
      "f5f0e6:Parchment"
      "faf3e0:Cream"
      "f4ecd8:Linen"
      "eae0cc:Sandstone"
      # soft tints
      "fce8e6:Blush"
      "fdeede:Peach"
      "f7f3d7:Buttermilk"
      "e6f4e6:Mint Cream"
      "def2f1:Seafoam"
      "e3f0fb:Ice Blue"
      "e8e6fb:Lavender Mist"
      "f3e6fb:Wisteria"
      "fbe6f3:Rose Quartz"
      # cool neutrals
      "eef1f5:Fog"
      "f5f5f5:Snow"
    )
    local entry=${palette[$((RANDOM % ${#palette[@]} + 1))]}
    local color=${entry%%:*}
    local name=${entry#*:}
    # Pick a readable foreground from the background's perceived luminance:
    # dark text on light backgrounds, light text on dark ones.
    local r=$((16#${color:0:2})) g=$((16#${color:2:2})) b=$((16#${color:4:2}))
    local lum=$(( (r * 299 + g * 587 + b * 114) / 1000 ))
    local fg
    # The 16 ANSI colors (black, red, green, yellow, blue, magenta, cyan,
    # white, then bright variants). Setting only the default foreground isn't
    # enough: prompts, ls, git, and dim/autosuggest text use these, and the
    # profile's "black" is invisible on dark backgrounds (and "white"/"yellow"
    # on light ones). So remap them to shades readable on the chosen bg.
    local ansi
    if (( lum > 140 )); then
      fg="1c1c22"  # near-black for light backgrounds
      ansi=(
        1c1c22 b3261e 1a7f37 8a6100 0550ae 8250df 0e7c86 57606a
        4b5563 cf222e 116329 7d4e00 0969da 6e40c9 1b7c83 24292f
      )
    else
      fg="dcdfe4"  # near-white for dark backgrounds
      ansi=(
        8b929c ff7b72 7ee787 e3b341 79c0ff d2a8ff 56d4dd dcdfe4
        a8b0bb ffa198 a5f3a5 f2cc60 a5d6ff e2c5ff 8be9fd ffffff
      )
    fi
    # Set background (OSC 11), a matching foreground (OSC 10), cursor
    # (OSC 12), and the ANSI palette (OSC 4).
    printf '\033]11;#%s\007' "$color"
    printf '\033]10;#%s\007' "$fg"
    printf '\033]12;#%s\007' "$fg"
    local i
    for i in {1..16}; do
      printf '\033]4;%d;#%s\007' $((i - 1)) "${ansi[$i]}"
    done
    # Show which theme this window got.
    printf '🎨 %s\n' "$name"
  }
  __random_term_bg
fi
