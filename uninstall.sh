#!/usr/bin/env bash
# Removes the random terminal background theme installed by install.sh.
set -euo pipefail

TARGET="$HOME/.random-term-bg.zsh"
ZSHRC="$HOME/.zshrc"

rm -f "$TARGET"
echo "Removed $TARGET"

if [[ -f "$ZSHRC" ]] && grep -qF '.random-term-bg.zsh' "$ZSHRC"; then
  cp "$ZSHRC" "$ZSHRC.bak"
  grep -vF -e '.random-term-bg.zsh' -e '# Random terminal background theme' "$ZSHRC.bak" > "$ZSHRC"
  echo "Removed source line from $ZSHRC (backup at $ZSHRC.bak)"
fi
echo "Done. New terminal windows will use your profile's default colors."
