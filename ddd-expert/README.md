# ddd-expert

Domain-Driven Design guidance grounded in Eric Evans' "Domain-Driven Design: Tackling Complexity in the Heart of Software" (2003).

## Installation

```bash
claude plugins add /path/to/ddd-expert
```

## Usage

The skill activates automatically when you're working on:
- Designing domain models
- Defining bounded contexts
- Structuring aggregates
- Extracting models from legacy code

You can also invoke it directly:
```
/ddd-expert
```

### Commands

**`/ddd-audit [path]`** - Perform a comprehensive domain model audit

```
/ddd-audit                    # Audit entire repository
/ddd-audit src/domain         # Audit specific directory
/ddd-audit src/orders         # Focus on a bounded context
```

The audit analyzes layered architecture, aggregate boundaries, entity/value object classification, domain services, repositories, ubiquitous language, bounded context boundaries, and common anti-patterns.

## What's Included

### Operating Modes

1. **New Domain Model** - Establish ubiquitous language, define bounded contexts, classify subdomains, apply tactical patterns
2. **Iterate and Improve** - Listen for friction, make implicit concepts explicit, pursue supple design
3. **Extract from Legacy** - Map the landscape, establish anti-corruption layers, mine domain concepts

### Reference Material

- **building-blocks.md** - Entities, Value Objects, Aggregates, Services, Repositories, Domain Events, Specifications, Factories, Modules
- **strategic-design.md** - Bounded Contexts, Context Mapping, Subdomains, Distillation
- **model-refinement.md** - Supple Design, Refactoring Toward Deeper Insight, Breakthroughs
- **legacy-extraction.md** - Anti-Corruption Layer, Strangler Fig, Domain Mining

## License

MIT
