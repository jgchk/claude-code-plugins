---
name: commit
description: Create a conventional commit with staged changes
---

# Commit

Create a Git commit following Conventional Commits and best practices.

## Parameters

- `$ARGUMENTS` - Optional commit message hint or scope (e.g., `fix the auth bug` or `feat(api)`)

## Workflow

1. **Check for project configuration**
   - Look for commitlint config (`.commitlintrc*`, `commitlint.config.*`)
   - Check for commit template (`.gitmessage`)
   - Adapt to any custom types, scopes, or length limits

2. **Analyze staged changes**
   - Run `git status` to confirm what's staged
   - Run `git diff --staged` to understand the changes
   - If nothing is staged, inform the user and suggest what to stage

3. **Determine commit type**
   - `feat`: New feature
   - `fix`: Bug fix
   - `docs`: Documentation only
   - `style`: Formatting, no code change
   - `refactor`: Code restructuring, no behavior change
   - `perf`: Performance improvement
   - `test`: Adding/updating tests
   - `build`: Build system or dependencies
   - `ci`: CI configuration
   - `chore`: Maintenance tasks

4. **Compose the commit message**
   - Subject: imperative mood, ≤50 chars, no period
   - Body: explain what and why (not how), wrap at 72 chars
   - Footer: issue references, breaking change notes

5. **Execute the commit**
   - Use `git commit -m` with the composed message
   - For multi-line messages, use heredoc format
   - Verify success with `git status`

## When to Include a Body

- Bug fixes: what was broken, user impact
- New features: use case, user benefit
- Refactors: what improvement this enables
- Performance: before/after metrics
- Breaking changes: migration path

Skip body for: typos, formatting, simple test additions, dependency bumps.

## Breaking Changes

When committing breaking changes:
1. Add an exclamation mark after type/scope (e.g., `feat(api)!: change response format`)
2. Include `BREAKING CHANGE:` footer with migration details

## Examples

```
/commit
```
Analyzes staged changes and creates an appropriate commit.

```
/commit fix the login timeout issue
```
Creates a fix commit with the hint guiding the message.

```
/commit feat(auth)
```
Creates a feature commit scoped to auth.
