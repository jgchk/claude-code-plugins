---
name: writing-git-commits
description: >
  Writes high-quality Git commit messages following Conventional Commits.
  Use when creating commits, reviewing commit messages, or committing changes.
---

# Writing Git Commits

## Pre-Commit Checks

Before writing a commit message, check for project-specific configuration:

1. **Commitlint config** - Look for `.commitlintrc*`, `commitlint.config.*`, or `commitlint` key in `package.json`. Adapt to custom types, scopes, or length limits.

2. **Commit template** - Check for `.gitmessage` or `git config commit.template`. Use as starting point if found.

## Workflow

1. Check for commitlint/template files
2. Run `git diff --staged` to understand changes
3. Determine type from change nature
4. Draft subject: imperative, ≤50 chars
5. Add body if the "why" isn't obvious
6. Add trailers (issue refs, breaking change notes)
7. Validate against any detected linting rules

## Structure

```
<type>[optional scope]: <subject>

[optional body - explain what changed and why]

[optional footer(s)]
```

**Types**: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`

**Scope**: lowercase, 1-2 words indicating affected area (e.g., `auth`, `api`, `ui`)

## When Body Is Required

- Bug fixes (what was broken, user impact)
- New features (use case, user benefit)
- Refactors (what improvement this enables)
- Performance changes (before/after metrics)
- Breaking changes (migration path)

Skip body for trivial changes: typo fixes, formatting, dependency bumps, simple test additions.

## Breaking Changes

Both required:
1. Add `!` after type/scope: `feat(api)!: change response format`
2. Include `BREAKING CHANGE:` footer with migration details

## Examples

```
fix(auth): prevent session timeout during file upload

Large file uploads triggered 401 errors because the session cookie
expired before completion. Extended session TTL during active uploads.

Fixes: #892
```

```
feat(api)!: add pagination to user list endpoint

Returns 50 users per page by default. Use `page` and `per_page`
query parameters to navigate.

BREAKING CHANGE: GET /users no longer returns all users in a
single response. Clients must handle pagination.
```

```
docs: fix typo in README installation section
```
