# Strategic Design Patterns

## Ubiquitous Language

A shared language between developers and domain experts, used in code, conversation, and documentation. The language IS the model.

**Principles**:
1. **One term, one meaning** (within a Bounded Context)
2. **Code speaks the language** — Class, method, variable names use domain terms
3. **Evolve together** — When experts refine terminology, code changes
4. **Reject jargon** — "EntityManager", "Handler", "Processor" often mask real concepts

**Building it**: Document key terms. Listen for natural domain expert language. Challenge vague words. Read code aloud—does it sound like domain conversation?

**Warning signs**: Developers use different words than experts. Same word means different things. Translation needed between code and conversation.

---

## Bounded Context

An explicit boundary within which a domain model applies. Terms have precise, consistent meaning within. Different contexts may use same terms differently.

**Why contexts exist**: Large domains can't fit one model. Different teams have different perspectives. Trying to unify everything creates confusion.

**Defining boundaries**:
- **Linguistic** — Where does language apply? Where do terms diverge?
- **Team** — Different teams often = different contexts
- **Subsystem** — Different services or deployment units

**Implementation**: Each context gets own codebase/module. Clear interfaces between. No shared domain model. Translation at boundaries.

**Example**:
```
E-commerce:
  Sales Context: "Customer" = buyer with shopping history
  Shipping Context: "Customer" = delivery address and preferences
  Billing Context: "Customer" = payment methods and invoices

Connected by ID, not shared class.
```

---

## Context Mapping

How Bounded Contexts relate to each other. Documents integration patterns and team relationships.

### Relationship Patterns

| Pattern | Description | When to Use |
|---------|-------------|-------------|
| **Shared Kernel** | Small common subset, both teams own | Tightly coupled teams, evolving together |
| **Customer/Supplier** | Upstream provides, downstream consumes | Clear dependency, cooperative teams |
| **Conformist** | Downstream adopts upstream wholesale | Upstream model good enough, low influence |
| **Anti-Corruption Layer** | Translation layer protects downstream | Legacy systems, different models, unreliable externals |
| **Open Host Service** | Well-defined API for multiple consumers | Many integrators, stable interface needed |
| **Published Language** | Documented shared integration language | Industry standards, formal contracts |
| **Separate Ways** | No integration, accept duplication | Integration cost > benefit |
| **Partnership** | Contexts evolve together, mutual influence | Aligned roadmaps, joint planning |

### Pattern Examples

**Customer/Supplier**: Order Management (upstream) provides order data to Shipping (downstream). Shipping team negotiates what data they need; Order Management commits to providing it.

**Conformist**: Your app integrates with Stripe's API. You adopt their model of Customers, Subscriptions, Invoices rather than translating to your own.

**Anti-Corruption Layer**: Integrating with 20-year-old mainframe. Build translation layer so new code never sees COBOL-era field names or data structures.

**Separate Ways**: Marketing analytics and Core Trading have no meaningful overlap. Accept some data duplication rather than force integration.

### Creating a Context Map

1. **Identify all Bounded Contexts** — Include external and legacy systems
2. **Document relationships** — Which pattern? Who is upstream/downstream?
3. **Note team dynamics** — Ownership, influence, pain points
4. **Make visible** — Diagram it, update as things change

---

## Subdomains

Natural divisions of business domain, independent of software boundaries. Guides where to invest modeling effort.

### Types

**Core Domain**
- What makes your business unique
- Competitive advantage
- Best modeling talent, heavy investment

*Example*: Route optimization for logistics, pricing models for trading.

**Supporting Subdomain**
- Necessary but not differentiating
- Good-enough models acceptable
- Build or customize off-the-shelf

*Example*: Employee scheduling for most companies.

**Generic Subdomain**
- Solved problems, standard solutions
- Not specific to your business
- Buy, don't build

*Example*: Email, payments, auth (usually).

### Strategic Implications

- **Core**: Best developers, deepest modeling, continuous refinement, protect with Anti-Corruption Layers
- **Supporting**: Don't over-engineer, simpler models fine, may outsource
- **Generic**: Use existing solutions, minimal modeling effort

---

## Distillation

Separating essential from non-essential, making Core Domain stand out.

**Core Domain Identification** — Ask: What's impossible to buy? What do experts get passionate about? What would cripple the business if done poorly?

**Domain Vision Statement** — One page max describing Core: value delivered, what distinguishes it, what's NOT in scope.

**Highlighted Core** — Mark Core in code with annotations, separate packages, more review attention.

**Cohesive Mechanisms** — Extract complex algorithms into separate modules. Mechanism does work, model uses mechanism.

**Segregated Core** — Core in own module. Dependencies point inward. Non-core depends on core, not vice versa.

**Generic Extraction** — Move generic functionality out (auth, logging, notifications). Don't let it clutter Core.

---

## Large-Scale Structure

Patterns for organizing multiple Bounded Contexts and teams. Adopt only when natural fit emerges—don't force.

**System Metaphor** — Overarching story explaining how pieces fit. Guides intuition. Examples: "Pipeline", "Marketplace", "Ledger".

**Responsibility Layers** — Domain layers (not technical). Example: Policy → Operations → Capability.

**Knowledge Level** — Separate configuration from operation. Knowledge level defines structure (e.g., Product catalog), operational level uses it (e.g., Order processing).

**Pluggable Component Framework** — Standard interfaces for interchangeable components. Use sparingly—high abstraction cost.
