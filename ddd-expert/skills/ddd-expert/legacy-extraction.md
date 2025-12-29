# Legacy Extraction

## Contents
- [Understanding the Legacy Landscape](#understanding-the-legacy-landscape)
- [Anti-Corruption Layer](#anti-corruption-layer)
- [Strangler Fig Pattern](#strangler-fig-pattern)
- [Domain Mining Techniques](#domain-mining-techniques)
- [Extraction Patterns](#extraction-patterns)
- [Practical Extraction Process](#practical-extraction-process)

---

## Understanding the Legacy Landscape

### Archeology Phase

**Map implicit Bounded Contexts**: Where does terminology differ? What organizational/technical boundaries exist? Where do concepts collide?

**Document current "language"**: Developer terms vs user terms. What's ambiguous or overloaded?

**Identify knowledge sources**:
- Code (often distorted by implementation)
- Database schemas (storage-centric, not domain-centric)
- UI/UX (reveals actual domain operations)
- People (experts, long-time developers)

### Finding the Real Model

**The code lies**—legacy often reflects old constraints, misunderstandings, convenience over correctness, conflicting models smashed together.

**Better sources**:
1. **User workflows** — What do users actually do? What sequence matters?
2. **Domain expert conversation** — Natural terminology, frustrations with software
3. **Edge cases** — Where does system fail to capture reality? What workarounds exist?

---

## Anti-Corruption Layer

The most critical pattern for legacy extraction. Protects new model from legacy corruption. (Abbreviated: ACL)

### Purpose

- Translate between legacy and new models
- Prevent legacy concepts leaking into new code
- Allow new model to be pure and coherent
- Enable incremental migration

### Components

| Component | Role |
|-----------|------|
| **Facade** | Simplified interface to legacy, hides complexity |
| **Adapter** | Converts between representations, transforms data |
| **Translator** | Semantic/conceptual conversion (not just data mapping) |

### Structure

```
Your New Model (Pure DDD)
         |
  [Anti-Corruption Layer]
    - Facade, Adapters, Translators
         |
Legacy System (Don't touch, don't trust)
```

**Principles**: New model never sees legacy types. All interaction through ACL. ACL is part of new system. ACL evolves as understanding improves.

### When ACL Complexity Explodes

**Signs**: Translation logic rivals domain logic. Many special cases. Constant changes.

**Responses**: Accept concepts don't map well—simplify translation. Question if integration is worth cost. Evaluate if translating too much.

---

## Strangler Fig Pattern

New system grows around old, features migrate incrementally, old system shrinks, eventually removed.

### Implementation

1. **Identify a seam** — API gateway, message queue, database view, UI layer

2. **Create new implementation** — Build new Bounded Context with ACL for remaining dependencies

3. **Route traffic** — New features to new system, unchanged to legacy. Use feature flags or routing rules.

4. **Expand incrementally** — Each feature shrinks legacy. Old code eventually has no traffic.

### Why Not Big Bang

Big bang (build entire new system, switch all at once) almost always worse:
- Higher risk, longer time to value, more likely to fail

Strangler Fig wins: Value delivered incrementally. Risk contained. Learning improves later phases. Can pause if needed.

---

## Domain Mining Techniques

### Event Storming (Adapted)

1. **List domain events** — What happens? Past tense: OrderPlaced, PaymentReceived. Mine from logs, triggers, UI.
2. **Identify commands** — What triggers each event?
3. **Find aggregates** — What's the consistency boundary?
4. **Discover policies** — What happens after events?

### Code Analysis

| Look For | Indicates |
|----------|-----------|
| Classes with IDs, tables with PKs | Entity candidates |
| Immutable data holders, grouped fields | Value Object candidates |
| Transaction boundaries, complex objects with collections | Aggregate candidates |
| Notification triggers, audit entries, state callbacks | Domain Event candidates |

### Interview Techniques

**Domain experts**: "Walk me through [process]", "What could go wrong?", "What do you call this?", "Why is this rule in place?"

**Developers**: "Most confusing part?", "Where does code diverge from reality?", "What can't you express cleanly?"

**Users**: "What do you actually use this for?", "What frustrates you?", "How would you describe your work?"

---

## Extraction Patterns

**Bubble Context** — Small, clean Bounded Context with minimal integration, protected by ACL. Grow it: add features, migrate functionality.

**Autonomous Bubble** — Can operate independently with own database. Minimal synchronization needs.

**Interchange Context** — When two legacies need to talk, create context dedicated to translation. Neither legacy changes.

---

## Practical Extraction Process

### Phase 1: Reconnaissance

1. **Identify starting point** — High-value, moderate-complexity, clear boundaries, experts available
2. **Map current state** — How does feature work? What systems involved? Integration points?
3. **Draft target model** — What Aggregates, Entities, Value Objects? What Ubiquitous Language?

### Phase 2: Foundation

1. **Design ACL** — What translations? Where do concepts map cleanly/poorly?
2. **Create new Bounded Context** — Clean structure, pure domain model, no legacy leaks
3. **Implement core model** — Key Aggregates, focus on invariants, test with experts

### Phase 3: Migration

1. **Set up routing** — How will traffic reach new system? How to switch gradually?
2. **Migrate incrementally** — Start low-risk, monitor, expand as confidence grows
3. **Retire legacy** — Remove unused code, document learnings, update Context Map

### Principles Throughout

- **Never compromise new model** to accommodate legacy
- **ACL takes the pain** — Keep domain clean
- **Expect iteration** — First extraction teaches you
- **Celebrate small wins** — Extraction is long-term work
