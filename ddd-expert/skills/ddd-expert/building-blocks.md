# DDD Building Blocks (Tactical Patterns)

## Contents
- [Entities](#entities)
- [Value Objects](#value-objects)
- [Aggregates](#aggregates)
- [Domain Services](#domain-services)
- [Repositories](#repositories)
- [Domain Events](#domain-events)
- [Specifications](#specifications)
- [Factories](#factories)
- [Modules](#modules)

---

## Entities

Objects defined by identity, not attributes. Two Entities with identical attributes but different IDs are different objects.

**Characteristics**: Unique identifier persists across time. Mutable state, stable identity. Equality based on ID only.

**When to use**: Object tracked through states, must distinguish between objects with same attributes, lifecycle matters.

**Implementation**:
- Prefer domain-meaningful IDs over UUIDs when possible
- Equals/hashCode based solely on identity
- Encapsulate state changes through intention-revealing methods
- Validate invariants on every state change

---

## Value Objects

Objects defined entirely by attributes. Two with same attributes are interchangeable.

**Characteristics**: Immutable. No identity—equality based on all attributes. Side-effect-free. Freely shareable.

**When to use**: Describes a characteristic or measurement, you care about what not which, immutability is natural.

**Implementation**:
- All fields final/readonly
- No setters—new instances for different values
- Equals/hashCode based on all attributes
- Rich behavior operating on own state

**Examples**: Money (amount + currency), Address, DateRange, Coordinates, Quantity.

---

## Aggregates

A cluster of Entities and Value Objects treated as a single unit for data changes. One Entity is the Root—all external access goes through it.

**Characteristics**: Define consistency boundary. Root controls access. Internal objects never referenced directly from outside. One Aggregate = one transaction. Reference other Aggregates by ID only.

**Design Rules**:

1. **Protect invariants** — Aggregate ensures all rules satisfied. No external code can create invalid state.

2. **Keep small** — Large Aggregates cause lock contention and complexity. Start with single-Entity, grow only when invariants demand.

3. **Reference by ID** — No direct object references to other Aggregates. Enables eventual consistency.

4. **One per transaction** — Cross-Aggregate transactions are a smell. Use Domain Events for eventual consistency.

**Structure**:
```
Root Entity:
  - Global identity, controls modifications
  - Publishes Domain Events, enforces invariants

Internal Entities:
  - Local identity (unique within Aggregate)
  - Never exposed, modified only through Root

Internal Value Objects:
  - Can be returned (immutable)
```

---

## Domain Services

Operations that don't belong to any Entity or Value Object. Domain concepts that are verbs, not nouns.

**Characteristics**: Stateless. Named after domain activities. Parameters and return values are domain objects.

**When to use**: Operation spans multiple Aggregates, represents a concept that isn't a thing, forcing it into Entity would distort model.

**Avoid when**: Behavior belongs on Entity/Value Object (anemic domain smell).

**Implementation**:
- Interface in domain layer
- No state—pure operations
- Intention-revealing name
- Should not handle infrastructure concerns

**Examples**: TransferService (moves money), RoutingService (calculates routes), PricingService (complex pricing rules).

---

## Repositories

Abstraction for retrieving and storing Aggregates. Provides illusion of in-memory collection of all Aggregates.

**Characteristics**: One per Aggregate type. Interface in domain, implementation in infrastructure. Returns fully reconstituted Aggregates.

**Design Principles**:

1. **Collection-like interface** — add(), remove(), findById(), query methods for common patterns

2. **Aggregate-centric** — Never return internals or raw data. Always complete Aggregates.

3. **Domain-named queries** — findActiveOrders() not findByStatusEqualsActive()

**Implementation**:
```
Interface (domain):
  - add(aggregate), remove(aggregate)
  - findById(id): Aggregate?
  - domain-specific finders

Implementation (infrastructure):
  - Handles ORM/SQL/NoSQL details
  - Reconstitutes Aggregates completely
```

---

## Domain Events

A record of something significant that happened. Represents a fact domain experts care about.

**Characteristics**: Immutable (represent past). Named in past tense (OrderPlaced, PaymentReceived). Capture state at occurrence. Part of Ubiquitous Language.

**When to use**: Experts talk about something "happening", need reactions across Aggregate boundaries, need audit trail, eventual consistency.

**Implementation**:
```
Structure:
  - Immutable Value Object
  - Timestamp of occurrence
  - Relevant state at that moment
  - Producing Aggregate's identity

Publishing:
  - Aggregate collects during operation
  - Dispatch after transaction commits
  - Or: store and process async
```

**Handling patterns**: Synchronous (within context), Asynchronous (across contexts), Event sourcing (events as source of truth).

---

## Specifications

Explicit predicates representing business rules. Make implicit selection criteria or validation rules first-class objects.

**Characteristics**: Encapsulate boolean logic. Combinable with AND, OR, NOT. Named in domain language. Reusable across contexts.

**When to use**: Complex selection criteria, validation rules that don't fit Entity/Value Object, rules that need combining or reusing.

**Forms**:

1. **Hard-coded Specification** — Logic in isSatisfiedBy() method
2. **Parameterized Specification** — Constructor takes criteria values
3. **Composite Specification** — Combines other specifications

**Implementation**:
```
interface Specification<T>:
  isSatisfiedBy(candidate: T): boolean
  and(other: Specification<T>): Specification<T>
  or(other: Specification<T>): Specification<T>
  not(): Specification<T>
```

**Examples**:
```
// Selection
eligibleForDiscount = PremiumCustomerSpec.and(OrderOverThresholdSpec)
readyToShip = PaidSpec.and(InStockSpec).and(NotFlaggedSpec)

// Validation
validAddress = HasStreetSpec.and(HasCitySpec).and(ValidPostalCodeSpec)
```

**Use cases**: Repository queries, policy validation, business rule engines, filtering collections.

---

## Factories

Encapsulate complex object creation, ensuring Aggregates/Entities created in valid state.

**When to use**: Complex creation logic, requires coordinating multiple objects, different scenarios need different approaches.

**Forms**: Factory methods on Roots (create related Entities), standalone Factory classes, factory methods on natural creators.

**Implementation**:
- Return fully valid Aggregates
- Encapsulate invariant checking at creation
- Hide implementation details

---

## Modules

Organize model elements into cohesive units reducing cognitive load.

**Principles**: High cohesion within, low coupling between. Names are Ubiquitous Language. Align with domain concepts, not technical layers.

**Guidance**: Modules tell a domain story. One Aggregate often = one module. Avoid splitting by technical concern (no separate "entities" and "repositories" modules).
