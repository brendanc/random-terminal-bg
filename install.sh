#!/usr/bin/env bash
# Installs the random terminal background theme for zsh.
# Copies random-term-bg.zsh to ~/.random-term-bg.zsh and sources it from
# ~/.zshrc. Safe to re-run: it updates the theme file and won't duplicate the
# source line.
# Usage: ./install.sh
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="$SCRIPT_DIR/random-term-bg.zsh"
TARGET="$HOME/.random-term-bg.zsh"
ZSHRC="$HOME/.zshrc"
SOURCE_LINE='[[ -f "$HOME/.random-term-bg.zsh" ]] && source "$HOME/.random-term-bg.zsh"'

if [[ ! -f "$SRC" ]]; then
  echo "Error: $SRC not found. Run this script from a full copy of the repo." >&2
  exit 1
fi

cp "$SRC" "$TARGET"
echo "Installed $TARGET"

touch "$ZSHRC"
if grep -qF '.random-term-bg.zsh' "$ZSHRC"; then
  echo "$ZSHRC already sources it — nothing to add."
else
  printf '\n# Random terminal background theme\n%s\n' "$SOURCE_LINE" >> "$ZSHRC"
  echo "Added source line to $ZSHRC"
fi

if [[ "${SHELL:-}" != */zsh ]]; then
  echo "Note: your login shell is ${SHELL:-unknown}, not zsh. This theme only runs in zsh."
fi
echo "Done. Open a new terminal window to see it."
