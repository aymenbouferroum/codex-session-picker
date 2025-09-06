#!/usr/bin/env bash
set -euo pipefail

SHELL_RC="${SHELL_RC:-$([ -n "${ZSH_VERSION-}" ] && echo "$HOME/.zshrc" || echo "$HOME/.bashrc")}"

echo "Installing codexr to your shell profile: $SHELL_RC"

SCRIPT_PATH="$(cd "$(dirname "$0")" && pwd)/codexr.sh"

BLOCK_START="# >>> codex-session-picker >>>"
BLOCK_END="# <<< codex-session-picker <<<<"

if grep -q "$BLOCK_START" "$SHELL_RC" 2>/dev/null; then
  awk -v start="$BLOCK_START" -v end="$BLOCK_END" '
    $0 ~ start {flag=1; next}
    $0 ~ end {flag=0; next}
    !flag {print}
  ' "$SHELL_RC" > "${SHELL_RC}.tmp"
  mv "${SHELL_RC}.tmp" "$SHELL_RC"
fi

cat >> "$SHELL_RC" <<EOF

$BLOCK_START
# Source codex-session-picker
if [ -f "$SCRIPT_PATH" ]; then
  . "$SCRIPT_PATH"
fi
$BLOCK_END
EOF

echo "Done. Restart your shell or run: source "$SHELL_RC""
