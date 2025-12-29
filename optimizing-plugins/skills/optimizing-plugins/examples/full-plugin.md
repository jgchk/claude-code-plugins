# Full-Featured Plugin Example

A comprehensive Claude Code plugin with all component types.

## Directory Structure

```
enterprise-toolkit/
├── .claude-plugin/
│   └── plugin.json              # ONLY file in this directory
├── commands/
│   ├── deploy.md
│   ├── status.md
│   └── rollback.md
├── skills/
│   ├── code-review/
│   │   ├── SKILL.md
│   │   ├── security-checklist.md
│   │   └── scripts/
│   │       └── scan-vulnerabilities.py
│   └── deployment/
│       ├── SKILL.md
│       └── reference.md
├── agents/
│   ├── security-reviewer.md
│   └── performance-analyzer.md
├── hooks/
│   └── hooks.json
├── scripts/
│   ├── format-code.sh
│   └── validate-config.py
├── .mcp.json
├── README.md
├── LICENSE
└── CHANGELOG.md
```

## Files

### .claude-plugin/plugin.json

```json
{
  "name": "enterprise-toolkit",
  "description": "Enterprise development toolkit with code review, deployment, and security features",
  "version": "2.1.0",
  "author": {
    "name": "DevOps Team",
    "email": "devops@company.com"
  },
  "homepage": "https://docs.company.com/claude-plugins/enterprise-toolkit",
  "repository": "https://github.com/company/enterprise-toolkit",
  "license": "MIT",
  "keywords": ["enterprise", "deployment", "security", "code-review"]
}
```

### skills/code-review/SKILL.md

```yaml
---
name: code-review
description: Reviews code for quality, security vulnerabilities, and best practices. Use when reviewing pull requests, analyzing code quality, checking for OWASP vulnerabilities, or assessing architecture patterns.
allowed-tools: Read, Grep, Glob, Bash(python:*)
---

# Code Review

## Overview

Comprehensive code review following enterprise standards.

## Review Process

1. Check code organization and naming
2. Verify error handling
3. Run security scan: `python scripts/scan-vulnerabilities.py`
4. Check test coverage

## Security Checklist

See [security-checklist.md](security-checklist.md) for detailed security review items.

## Output Format

Provide findings as:
- 🔴 CRITICAL: Must fix before merge
- 🟠 HIGH: Should fix before merge
- 🟡 MEDIUM: Consider fixing
- 🟢 LOW: Nice to have
```

### hooks/hooks.json

```json
{
  "hooks": [
    {
      "event": "pre-commit",
      "command": "python scripts/validate-config.py",
      "timeout": 30000
    }
  ]
}
```

### agents/security-reviewer.md

```yaml
---
name: security-reviewer
description: Specialized agent for security-focused code review
allowed-tools: Read, Grep, Glob
---

# Security Reviewer Agent

Focus exclusively on security concerns when reviewing code.

## Responsibilities

1. Check for OWASP Top 10 vulnerabilities
2. Identify hardcoded credentials
3. Review authentication/authorization logic
4. Check input validation
```

## Key Points

1. All components at root level (commands/, skills/, agents/, hooks/)
2. `.claude-plugin/` contains ONLY plugin.json
3. Skills use progressive disclosure (main SKILL.md links to reference files)
4. Scripts bundled with relevant skills
5. Skill descriptions are specific with trigger keywords
6. Proper semantic versioning
7. Complete metadata for distribution
