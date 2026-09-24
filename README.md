# random-term-bg

Give every new terminal window its own background color, so windows and tabs
are easy to tell apart. The text colors are always readable on it.

```
🎨 Deep Teal
```

Each time a zsh shell starts, it picks a random background from about 50 named
colors (dark and light, across the whole color wheel). Then it sets text colors
to match:

- **Main text and cursor:** near-white on dark backgrounds, near-black on light ones.
- **The 16 ANSI colors:** the colors used by prompts, `ls`, `git`, dimmed text,
  autosuggestions and so on. These are changed to readable shades too, so you
  never get black text on a dark background or white/yellow text on a light one.

It's plain zsh plus terminal escape codes, so there are no dependencies. The
colors only apply to the current window and reset when it closes.

## Install

```sh
git clone <repo-url> random-term-bg
cd random-term-bg
./install.sh
```

Then open a new terminal window.

The installer copies `random-term-bg.zsh` to `~/.random-term-bg.zsh` and adds
one line to `~/.zshrc` to load it. Running it again is safe: it updates the
theme file and won't add the line twice.

## Uninstall

```sh
./uninstall.sh
```

This removes `~/.random-term-bg.zsh` and the line in `~/.zshrc`. It saves a
backup of your old `~/.zshrc` as `~/.zshrc.bak`.

## Check the colors

Run this in a new window to print all 16 ANSI colors:

```sh
for i in {0..15}; do print -P "%F{$i}color $i%f"; done
```

Every line should be readable against the background.

## Customize

Edit `random-term-bg.zsh`, then re-run `./install.sh`.

- **Add or remove backgrounds:** edit the `palette` list. Each entry is
  `"hexcolor:Name"`, e.g. `"0a2e2e:Deep Teal"`. It goes in the dark or light
  group automatically based on its brightness.
- **Only dark (or only light) backgrounds:** delete the other section of the
  `palette` list.
- **Change the dark/light cutoff:** change the `lum > 140` check. Brightness
  ranges from 0 (black) to 255 (white).
- **Change the text colors:** edit `fg` and the two 16-color `ansi` lists.

## How it works

| Escape code | Sets |
|---|---|
| `OSC 11` | Background color |
| `OSC 10` | Main text color |
| `OSC 12` | Cursor color |
| `OSC 4`  | ANSI colors 0–15 |

Brightness is calculated as `(299·R + 587·G + 114·B) / 1000`. Backgrounds above
140 count as light.

## Compatibility

- **Shell:** zsh only. It runs in interactive shells only, so scripts aren't affected.
- **Terminals:** iTerm2, Apple Terminal, kitty, WezTerm, Alacritty, Ghostty, and
  most modern terminals that support the escape codes above. If a terminal
  ignores `OSC 4`, the background and main text still change, but some ANSI
  colors may be hard to read.
