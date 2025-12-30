#!/bin/bash
#
# Detects which plugins have changes (staged or in a commit).
# Usage: ./detect-changed-plugins.sh [--from-commit SHA]
# Output: space-separated plugin names
#

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

if [[ "${1:-}" == "--from-commit" ]]; then
  # From specific commit (for CI)
  files=$(git diff-tree --no-commit-id --name-only -r "$2")
else
  # From staged files (for hook)
  files=$(git diff --cached --name-only)
fi

plugins=""
for file in $files; do
  # Skip plugin.json files to prevent loops
  [[ "$file" == *"/plugin.json" ]] && continue

  # Only consider files in the plugins/ directory
  [[ "$file" != plugins/* ]] && continue

  # Get plugin name (second path component: plugins/<plugin-name>/...)
  plugin=$(echo "$file" | cut -d'/' -f2)

  # Check if it's a plugin directory
  [[ -f "$REPO_ROOT/plugins/$plugin/.claude-plugin/plugin.json" ]] || continue

  # Add to list if not already present
  [[ " $plugins " != *" $plugin "* ]] && plugins="$plugins $plugin"
done

# Trim leading space and output
echo ${plugins# }
