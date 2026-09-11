#!/usr/bin/env bash
# Symlinks skills into ~/.claude/skills/ and path-scoped rules into ~/.claude/rules/.
# Run from anywhere: ./install.sh
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILLS_DEST="$HOME/.claude/skills"
RULES_DEST="$HOME/.claude/rules"

# link <source> <target>: create or refresh a symlink, but never clobber a real file.
link() {
  local src="$1" target="$2" name
  name="$(basename "$target")"
  if [ -L "$target" ]; then
    rm "$target"; ln -s "$src" "$target"; echo "  updated  $name"
  elif [ -e "$target" ]; then
    echo "  skipped  $name  (exists, not a symlink — remove it manually)"
  else
    ln -s "$src" "$target"; echo "  linked   $name"
  fi
}

mkdir -p "$SKILLS_DEST" "$RULES_DEST"

echo "Skills → $SKILLS_DEST"
while IFS= read -r skill_md; do
  skill_dir="$(dirname "$skill_md")"
  link "$skill_dir" "$SKILLS_DEST/$(basename "$skill_dir")"
done < <(find "$REPO_DIR" -name "SKILL.md" -not -path "*/.git/*" | sort)

echo ""
echo "Rules → $RULES_DEST"
if [ -d "$REPO_DIR/rules" ]; then
  while IFS= read -r rule_md; do
    link "$rule_md" "$RULES_DEST/$(basename "$rule_md")"
  done < <(find "$REPO_DIR/rules" -name "*.md" ! -iname "README.md" -not -path "*/.git/*" | sort)
fi

echo ""
echo "Done. Restart Claude Code (or open a new session) to pick up changes."
