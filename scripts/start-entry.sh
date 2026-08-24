#!/bin/bash -e
#
# start-entry.sh -- append a new timestamped log entry and open it for editing.
#
# Usage:  ./scripts/start-entry.sh
#
# Run this every time you sign on AND every time you sign off.

# Always run from the repository root, no matter where you invoke it from.
cd "$(dirname "$0")/.."

# Bring down anything that changed on GitHub before you start writing.
# If this fails (no network, unmerged changes), keep going -- writing the
# entry matters more than being in sync at this exact moment.
git pull --quiet 2>/dev/null || echo "NOTE: git pull skipped (no upstream or no network)."

FILENAME="logs/$(date +'%Y-%m-%d').log.md"
mkdir -p logs
touch "$FILENAME"

# Blank line first, but only if the file already has content -- keeps entries
# separated without leaving a stray blank line at the top of a brand-new file.
if [ -s "$FILENAME" ]; then
  echo "" >> "$FILENAME"
fi

{
  echo "# $(date +'%A, %B %e, %Y %I:%M %p')"
  echo ""
  echo "- [ ] "
} >> "$FILENAME"

echo "Started an entry in $FILENAME"

# Open in VS Code if we can find it; otherwise say so rather than failing.
if command -v code >/dev/null 2>&1; then
  code "$FILENAME"
elif [ -x "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" ]; then
  "/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code" "$FILENAME"
elif [ -n "${EDITOR:-}" ]; then
  "$EDITOR" "$FILENAME"
else
  echo "Could not find VS Code on your PATH."
  echo "In VS Code: Cmd+Shift+P -> 'Shell Command: Install code command in PATH'"
  echo "For now, open $FILENAME yourself."
fi
