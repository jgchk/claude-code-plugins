#!/bin/bash
#
# Bumps the version in plugin.json files.
# Usage: ./bump-versions.sh <major|minor|patch> <plugin1> [plugin2] ...
#

set -euo pipefail
REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

bump_type="$1"
shift

for plugin in "$@"; do
  plugin_json="$REPO_ROOT/plugins/$plugin/.claude-plugin/plugin.json"
  [[ -f "$plugin_json" ]] || continue

  # Extract current version
  version=$(grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "$plugin_json" | sed 's/.*"\([0-9.]*\)".*/\1/')
  [[ -z "$version" ]] && continue

  # Parse semver
  IFS='.' read -r major minor patch <<< "$version"

  # Bump
  case "$bump_type" in
    major) major=$((major + 1)); minor=0; patch=0 ;;
    minor) minor=$((minor + 1)); patch=0 ;;
    patch) patch=$((patch + 1)) ;;
  esac

  new_version="$major.$minor.$patch"

  # Update file (using sed -i with backup for macOS compatibility)
  sed -i.bak "s/\"version\"[[:space:]]*:[[:space:]]*\"[^\"]*\"/\"version\": \"$new_version\"/" "$plugin_json"
  rm -f "$plugin_json.bak"

  echo "Bumped $plugin: $version → $new_version"
done
