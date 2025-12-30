---
name: audit
description: Audit domain model for DDD patterns, anti-patterns, and improvement opportunities
argument-hint: "[path/to/audit]"
allowed-tools: Read, Glob, Grep, Bash, Task
---

# Domain Model Audit

Perform a comprehensive DDD audit on a codebase or specific area, identifying patterns, anti-patterns, and opportunities for model refinement.

## Parameters

- `$ARGUMENTS` - Optional path to audit (e.g., `src/domain`, `src/orders`). Defaults to the entire repository if not specified.

## Audit Scope

Determine the target:
- If `$ARGUMENTS` is provided, focus the audit on that path
- If no arguments, audit the entire repository's domain model

## Audit Checklist

### 1. Layered Architecture Assessment

Evaluate separation of concerns:
- Is there a clear domain layer isolated from infrastructure?
- Does the application layer remain thin (coordination only, no business logic)?
- Are persistence concerns leaking into domain objects?
- Is the UI directly manipulating domain objects?

### 2. Aggregate Analysis

For each aggregate found:
- **Boundary validity**: Does it protect a true consistency boundary?
- **Size**: Is it too large? Could it be split while maintaining invariants?
- **References**: Are other aggregates referenced by identity only (not direct object reference)?
- **Transaction scope**: One aggregate per transaction?
- **Root clarity**: Is the aggregate root clearly identifiable?

### 3. Entity vs Value Object Classification

Review domain objects:
- Are things modeled as Entities that should be Value Objects?
- Do Value Objects have identity they shouldn't have?
- Are Value Objects immutable?
- Do Entities have meaningful identity beyond database IDs?

### 4. Domain Service Evaluation

Check for:
- Services that should be methods on aggregates
- Business logic scattered in application services
- Stateful domain services (they should be stateless)
- Missing domain services (operations that don't belong to any entity)

### 5. Repository Patterns

Assess repositories:
- One repository per aggregate root?
- Are repositories leaking query complexity into domain?
- Is there direct database access bypassing repositories?
- Do repositories return domain objects (not DTOs or primitives)?

### 6. Ubiquitous Language Audit

Evaluate naming and terminology:
- Do class/method names reflect domain concepts?
- Is terminology consistent across the codebase?
- Are there technical names where domain names should be?
- Do names match what domain experts would use?

### 7. Bounded Context Boundaries

Identify context issues:
- Are there implicit bounded contexts that should be explicit?
- Is there terminology collision (same word, different meanings)?
- Are contexts properly isolated or bleeding into each other?
- Is there an anti-corruption layer where needed?

### 8. Anti-Pattern Detection

Look for common DDD anti-patterns:
- **Anemic Domain Model**: Entities with only getters/setters, logic in services
- **God Aggregate**: Single aggregate trying to do everything
- **Primitive Obsession**: Using primitives instead of Value Objects
- **Feature Envy**: Services doing work that belongs in domain objects
- **Shotgun Surgery**: Single domain change requiring many file modifications
- **Leaky Abstractions**: Infrastructure concepts in domain layer

### 9. Model Refinement Opportunities

Identify potential improvements:
- Implicit concepts that should be made explicit
- Specifications that could be extracted
- Policies or strategies that could be first-class objects
- Domain events that could improve decoupling
- Factories that could encapsulate complex creation

## Output Format

Structure the audit report as:

```markdown
# Domain Model Audit Report

## Executive Summary
[High-level findings: strengths, critical issues, recommended priorities]

## Layered Architecture
[Findings with specific file/line references]

## Aggregates
[Analysis of each aggregate found]

## Entities and Value Objects
[Classification issues and recommendations]

## Domain Services
[Service layer analysis]

## Repositories
[Repository pattern compliance]

## Ubiquitous Language
[Terminology and naming issues]

## Bounded Contexts
[Context boundary analysis]

## Anti-Patterns Found
[Specific anti-patterns with examples]

## Recommended Improvements
[Prioritized list of actionable improvements]
```

## Guidelines

- Reference specific files and line numbers for all findings
- Distinguish between critical issues and minor improvements
- Provide concrete refactoring suggestions, not just problem identification
- Consider the context—not every codebase needs perfect DDD
- Focus on high-impact improvements that will provide the most value
- Use the ddd-expert skill's context files for pattern reference when needed
