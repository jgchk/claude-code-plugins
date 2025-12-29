# Skill with Tool Restrictions Example

Demonstrates how to create a skill with restricted tool access.

## Directory Structure

```
read-only-analyzer/
├── SKILL.md
├── analysis-guide.md
└── scripts/
    └── generate-report.py
```

## SKILL.md

```yaml
---
name: read-only-analyzer
description: Analyzes codebase structure, dependencies, and patterns without making changes. Use when exploring unfamiliar code, understanding architecture, or generating codebase reports.
allowed-tools: Read, Grep, Glob, Bash(python:*)
---

# Read-Only Codebase Analyzer

## Overview

Safely analyze codebases without risk of modification. Tool access is restricted to read-only operations.

## Analysis Types

### Structure Analysis
- Directory organization
- File type distribution
- Module dependencies

### Pattern Analysis
- Design patterns used
- Code conventions
- Naming patterns

### Dependency Analysis
- External dependencies
- Internal module coupling
- Circular dependencies

## Generate Report

To generate a full analysis report:

```bash
python scripts/generate-report.py --output report.md
```

## Detailed Guide

See [analysis-guide.md](analysis-guide.md) for comprehensive analysis procedures.
```

## Key Points

### allowed-tools Field

The `allowed-tools` field restricts what tools Claude can use when this skill is active:

- `Read` - Read files
- `Grep` - Search file contents
- `Glob` - Find files by pattern
- `Bash(python:*)` - Run python commands only

### Bash Tool Patterns

- `Bash` - All bash commands allowed
- `Bash(python:*)` - Only commands starting with `python`
- `Bash(npm:*, yarn:*)` - Only npm and yarn commands
- `Bash(git:status, git:diff)` - Only specific git commands

### Why Use Tool Restrictions?

1. **Safety**: Prevent accidental modifications
2. **Reduced prompts**: No permission dialogs for allowed tools
3. **Clear scope**: Users know what the skill can/can't do
4. **Trust**: Read-only skills can run without supervision
