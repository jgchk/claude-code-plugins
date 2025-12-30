#!/bin/bash
#
# Generates .claude-plugin/marketplace.json from all plugins in this directory.
# Idempotent: always reflects current state (adds new, removes missing).
#
# Each subdirectory containing .claude-plugin/plugin.json is treated as a plugin.

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MARKETPLACE_DIR="$REPO_ROOT/.claude-plugin"
MARKETPLACE_FILE="$MARKETPLACE_DIR/marketplace.json"

# Create .claude-plugin directory if needed
mkdir -p "$MARKETPLACE_DIR"

# Start building the plugins JSON array
plugins_json="["
first=true

# Find all plugin directories with .claude-plugin/plugin.json
for dir in "$REPO_ROOT"/plugins/*/; do
  dir_name="$(basename "$dir")"
  plugin_file="$dir/.claude-plugin/plugin.json"

  # Skip if no plugin.json
  [[ ! -f "$plugin_file" ]] && {
    echo "Warning: Skipping $dir_name - no .claude-plugin/plugin.json found" >&2
    continue
  }

  # Extract fields from plugin.json using sed/grep (no jq dependency)
  name=$(grep -o '"name"[[:space:]]*:[[:space:]]*"[^"]*"' "$plugin_file" | head -1 | sed 's/.*:[[:space:]]*"\([^"]*\)"/\1/')
  description=$(grep -o '"description"[[:space:]]*:[[:space:]]*"[^"]*"' "$plugin_file" | head -1 | sed 's/.*:[[:space:]]*"\([^"]*\)"/\1/')
  version=$(grep -o '"version"[[:space:]]*:[[:space:]]*"[^"]*"' "$plugin_file" | head -1 | sed 's/.*:[[:space:]]*"\([^"]*\)"/\1/')

  # Skip if no name found
  [[ -z "$name" ]] && {
    echo "Warning: Skipping $dir_name - no name in plugin.json" >&2
    continue
  }

  # Add comma separator for subsequent entries
  if [ "$first" = true ]; then
    first=false
  else
    plugins_json+=","
  fi

  # Build plugin entry
  plugin_entry="
    {
      \"name\": \"$name\",
      \"description\": \"$description\",
      \"source\": \"./plugins/$dir_name\""

  # Add version if present
  if [[ -n "$version" ]]; then
    plugin_entry+=",
      \"version\": \"$version\""
  fi

  plugin_entry+="
    }"

  plugins_json+="$plugin_entry"
done

plugins_json+=$'\n  ]'

# Count plugins
plugin_count=$(echo "$plugins_json" | grep -c '"name"' || echo 0)

# Generate the complete marketplace.json
cat >"$MARKETPLACE_FILE" <<EOF
{
  "name": "jake-claude-code-plugins",
  "description": "Local collection of Claude Code plugins",
  "owner": {
    "name": "Local",
    "email": ""
  },
  "plugins": $plugins_json
}
EOF

echo "Generated $MARKETPLACE_FILE with $plugin_count plugin(s)"
