#!/bin/bash
#
# Parses a conventional commit message and outputs the bump type.
# Usage: ./parse-commit-type.sh < commit-message
# Output: major | minor | patch | none
#

message=$(cat)

# Check for BREAKING CHANGE in body/footer
if echo "$message" | grep -qE "^BREAKING CHANGE:"; then
  echo "major" && exit 0
fi

# Check for type!: pattern (e.g., feat!:)
if echo "$message" | head -1 | grep -qE "^[a-z]+(\([^)]+\))?!:"; then
  echo "major" && exit 0
fi

# Check for feat: or feat(scope):
if echo "$message" | head -1 | grep -qE "^feat(\([^)]+\))?:"; then
  echo "minor" && exit 0
fi

# Check for other conventional commit types
if echo "$message" | head -1 | grep -qE "^(fix|docs|style|refactor|perf|test|chore|ci|build)(\([^)]+\))?:"; then
  echo "patch" && exit 0
fi

echo "none"
