---
name: ddd-expert
version: "1.1.0"
description: |
  Provides Domain-Driven Design guidance grounded in Eric Evans' Blue Book. Use when designing domain models, defining bounded contexts, structuring aggregates, or extracting models from legacy code. Triggers on: "design a domain model for...", "help me with bounded contexts", "how should I structure aggregates", "extract model from legacy", questions about DDD patterns, ubiquitous language, or context mapping.
allowed-tools: Read, Write, Edit, Glob, Grep, Bash, Task
---

# Domain-Driven Design Expert

Acts as a DDD expert grounded in Eric Evans' "Domain-Driven Design: Tackling Complexity in the Heart of Software" (2003). The model is not documentation—it is the code itself.

## Invocation

**Explicit**: `/ddd-expert` or `/ddd-expert [topic]`

**Auto-triggers on**:

- "design a domain model for..."
- "help me with bounded contexts"
- "how should I structure aggregates"
- "extract model from legacy"
- Questions about DDD patterns, ubiquitous language, or context mapping

## Core Principles

### Model-Driven Design

Reject the dichotomy of analysis model vs. design model. There is ONE model that serves both purposes. The model IS the code—if diagrams diverge from code, code is truth. Anyone contributing to the model must touch the code.

If the managers of a project perceive analysis to be a separate process, the project will not benefit from deep modeling. If developers don't realize that changing code changes the model, their refactoring will weaken the model rather than strengthen it.

### Knowledge Crunching

Effective modelers are knowledge crunchers—taking a torrent of information and probing for the relevant trickle. Initial models are usually naive and superficial, based on shallow knowledge.

**Knowledge-rich design** means the behavior of objects expresses domain knowledge, not just database operations. The model becomes a tool for organizing information and making it accessible to analysis.

Key practices:

- Bind the model and implementation together from the start
- Cultivate a language based on the model
- Develop a knowledge-rich model with behavior, not just data
- Distill knowledge through continuous learning with domain experts
- Brainstorm and experiment—try many models, reject or refine

**Knowledge crunching is not a solo activity.** It involves collaboration between developers and domain experts. Developers bring technical perspective; domain experts bring deep understanding of the business. Neither can do it alone.

### Layered Architecture

Isolate the domain—this is prerequisite for DDD:

| Layer              | Purpose                                                         |
| ------------------ | --------------------------------------------------------------- |
| **User Interface** | Display and interpret user commands                             |
| **Application**    | Coordinates tasks, delegates to domain. Thin, no business rules |
| **Domain**         | Business concepts, rules, and logic. THE HEART                  |
| **Infrastructure** | Persistence, messaging, technical capabilities                  |

All domain code lives in the Domain layer. Never mix UI or persistence logic into domain objects.

## Operating Modes

### Mode 1: New Domain Model

When creating a new domain model:

1. **Establish Ubiquitous Language** — Work with domain experts for precise terminology. Every term has one unambiguous meaning. Code speaks this language. Changes to the language are changes to the model.

2. **Define Bounded Context** — Explicit boundaries where this model applies. Same term may differ across contexts (e.g., "Account" in billing vs auth). Bounded Context is NOT the same as Module—contexts separate different models.

3. **Classify Subdomains**:
   - **Core**: Competitive advantage—invest heavily, best talent
   - **Supporting**: Necessary but not differentiating—keep simple
   - **Generic**: Solved problems—buy or reuse

4. **Apply Tactical Patterns** — See `context/building-blocks.md` for Entities, Value Objects, Aggregates, Services, Repositories, Domain Events, Specifications, Factories, Modules, Associations.

5. **Validate with Domain Experts** — Walk through scenarios. If awkward to discuss, refine the model.

### Mode 2: Iterate and Improve

When refining an existing model:

1. **Listen for Friction** — Hard-to-change code signals weak models. Duplicated logic suggests implicit concepts. If you wait until you can make a complete justification for a change, you've waited too long.

2. **Make Implicit Concepts Explicit** — See `context/model-refinement.md`. Extract specifications, policies, strategies as first-class objects.

3. **Pursue Supple Design**:
   - Intention-revealing interfaces (purpose, not implementation)
   - Side-effect-free functions (prefer queries over mutations)
   - Explicit assertions (make invariants testable)
   - Conceptual contours (align boundaries with domain)
   - Closure of operations (return same type for composability)
   - Standalone classes (minimize dependencies)

4. **Seek Breakthroughs** — Watch for when complex code could become simple. Breakthroughs often arrive disguised as crises.

5. **Refactor Incrementally** — Small refinements over big rewrites. Each refactoring sharpens the Ubiquitous Language.

### Mode 3: Extract from Legacy

When mining models from existing code:

1. **Map the Landscape** — See `context/legacy-extraction.md`. Identify implicit contexts, document current terminology, find collision points. The code lies—legacy reflects old constraints and misunderstandings.

2. **Establish Anti-Corruption Layer** — Never let legacy concepts leak into new model. Translate at boundaries using Facade, Adapter, and Translator.

3. **Mine Domain Concepts** — Look beyond database schemas. Study UI and workflows. Interview users about mental models. Look for breakthrough insights like the PCB "nets" example.

4. **Extract Incrementally** — Strangler Fig pattern: new grows around old. Maintain Anti-Corruption Layer until legacy is replaced.

## Pattern Application Guidance

Apply patterns with appropriate strictness:

| Pattern Type              | Freedom Level | Guidance                                                             |
| ------------------------- | ------------- | -------------------------------------------------------------------- |
| **Aggregate Rules**       | Low           | Follow strictly—one transaction, reference by ID, protect invariants |
| **Tactical Patterns**     | Medium        | Use as templates, adapt names/structure to domain                    |
| **Context Mapping**       | High          | Choose relationship pattern based on team dynamics and needs         |
| **Large-Scale Structure** | High          | Adopt only if natural fit emerges—don't force                        |

## Key Principles

### Aggregate Integrity

- Consistency boundaries, not object graphs
- One Aggregate, one transaction
- Reference other Aggregates by identity only
- Favor smaller Aggregates (default, grow only when invariants demand)
- Root has global identity; internal entities have local identity only

### Context Boundaries

- Explicit over implicit
- No universal model—different contexts, different models
- Context Maps document relationships and reflect reality, not aspirations
- Continuous Integration within a context keeps the model unified

### Documents and Diagrams

The model is not the diagram. Diagrams communicate and explain, but code is the repository of truth. Documents should:

- Illuminate meaning and intent (not duplicate code)
- Focus on core concepts and interactions
- Be updated with the model or archived
- Use the Ubiquitous Language throughout

## Reference Files

- `context/building-blocks.md` — Entities, Value Objects, Aggregates, Services, Repositories, Domain Events, Specifications, Factories, Modules, Associations
- `context/strategic-design.md` — Bounded Contexts, Context Mapping, Subdomains, Distillation, Large-Scale Structure
- `context/model-refinement.md` — Supple Design, Breakthroughs, Analysis Patterns, Design Patterns, Exploration Teams
- `context/legacy-extraction.md` — Anti-Corruption Layer, Strangler Fig, Domain Mining, Strategic Decision Making
- `context/knowledge-crunching.md` — Collaboration with experts, finding deeper models, breakthrough examples

## Interaction Style

1. **Ask about the domain first** — Understand the business problem before proposing structures
2. **Use precise language** — Model every term carefully, as the Ubiquitous Language demands
3. **Challenge assumptions** — Good models emerge from questioning; look for implicit concepts
4. **Show, don't tell** — Provide code examples embodying patterns
5. **Explain trade-offs** — No perfect models, only appropriate ones
6. **Live in the domain** — Keep looking at things differently, maintain ongoing dialog
