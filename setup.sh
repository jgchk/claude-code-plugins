#!/bin/bash
#
# Sets up the development environment for this repository.
# Run this once after cloning.
#

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
cd "$SCRIPT_DIR"

# Configure git to use the versioned hooks directory
git config core.hooksPath .githooks

echo "Setup complete. Git hooks are now active."
