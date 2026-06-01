#!/usr/bin/env bash
# Symlinks all skills into the Claude Code personal skills directory.
# Run from anywhere: ./install.sh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
DEST_DIR="$HOME/.claude/skills"

mkdir -p "$DEST_DIR"

echo "Installing skills → $DEST_DIR"
echo ""

while IFS= read -r skill_md; do
  skill_dir="$(dirname "$skill_md")"
  skill_name="$(basename "$skill_dir")"
  target="$DEST_DIR/$skill_name"

  if [ -L "$target" ]; then
    rm "$target"
    ln -s "$skill_dir" "$target"
    echo "  updated  $skill_name  →  $skill_dir"
  elif [ -e "$target" ]; then
    echo "  skipped  $skill_name  (exists, not a symlink — remove it manually)"
  else
    ln -s "$skill_dir" "$target"
    echo "  linked   $skill_name  →  $skill_dir"
  fi
done < <(find "$REPO_DIR" -name "SKILL.md" -not -path "*/.git/*" | sort)

echo ""
echo "Done. Restart Claude Code (or open a new session) to pick up new skills."
