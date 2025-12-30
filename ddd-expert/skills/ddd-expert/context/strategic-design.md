# Strategic Design Patterns

## Ubiquitous Language

A shared language between developers and domain experts, used in code, conversation, and documentation. The language IS the model.

**Principles**:
1. **One term, one meaning** (within a Bounded Context)
2. **Code speaks the language** — Class, method, variable names use domain terms
3. **Evolve together** — When experts refine terminology, code changes
4. **Reject jargon** — "EntityManager", "Handler", "Processor" often mask real concepts

**The language includes**:
- Names of classes and prominent operations
- Terms to discuss rules made explicit in the model
- Names of high-level organizing principles
- Names of patterns applied to the domain model

**Conversation Without Ubiquitous Language**:
> Developer: "When the routing service receives a route request with the origin and destination codes, it queries the repository for all matching legs, filters based on hazmat codes, and builds an itinerary object."
> Expert: "What's a leg? And what's an itinerary? We talk about voyages and routes..."

**Conversation With Ubiquitous Language**:
> Developer: "The Routing Service finds a Route for a Cargo by finding Legs that connect the origin to the destination, ensuring any required customs clearance."
> Expert: "And it needs to respect the Customer's transit time requirements?"
> Developer: "Yes, the Route Specification constrains which Itineraries are acceptable."

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

**Example: The "Charge" Debacle**

Two teams on one project:
- Team A: Customer invoicing — "Charge" means amount billed to customer
- Team B: Vendor payment — "Charge" means expense posted to accounts

They tried to share a "Charge" class. Chaos ensued:
- Mystery records appeared in the database
- Reports crashed
- Each team's assumptions about Charge behavior contradicted the other's

Solution: Explicit Bounded Contexts with separate CustomerCharge and SupplierCharge classes.

**E-commerce Example**:
```
Sales Context: "Customer" = buyer with shopping history
Shipping Context: "Customer" = delivery address and preferences
Billing Context: "Customer" = payment methods and invoices

Connected by ID, not shared class.
```

**Recognizing splinters**:
- **Duplicate concepts**: Same concept represented differently
- **False cognates**: Same term used for different concepts (like "embarazada" in Spanish doesn't mean "embarrassed")

**Bounded Context is NOT the same as Module**:
- Modules organize within ONE model
- Bounded Contexts separate DIFFERENT models
- A Bounded Context might contain many Modules

---

## Continuous Integration (Within a Context)

Within a Bounded Context, apply processes to keep the model unified:

- Frequent merging of all code
- Automated test suites
- Relentless exercise of the Ubiquitous Language
- Build/test cycles that flag model fragmentation

**Two levels of integration**:
1. **Model concepts**: Through constant communication and exercising the language
2. **Implementation artifacts**: Through merge/build/test processes

**Without Continuous Integration**, even a small team will diverge. Developers make different assumptions, use terms inconsistently, and duplicate behavior because they're unaware of existing implementations.

---

## Context Mapping

How Bounded Contexts relate to each other. Documents integration patterns and team relationships.

### Creating a Context Map

1. **Identify all Bounded Contexts** — Include external and legacy systems
2. **Name each context** — Names enter Ubiquitous Language
3. **Document relationships** — Which pattern? Who is upstream/downstream?
4. **Note team dynamics** — Ownership, influence, pain points
5. **Make visible** — Diagram it, update as things change

**The Context Map reflects reality, not aspirations.** Map what IS, not what you wish it were. Then you can plan changes.

**Example Context Map**:
```
[Booking Context] <---> [Transport Network Context]
         |                        |
         |                        |
   (translation)            (translation)
         |                        |
         v                        v
    [Legacy Cargo Tracking] [Voyage Schedule]
```

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

### Pattern Details

**Shared Kernel**:
- Small, explicitly identified shared part
- Special status requiring coordination for changes
- Both teams build off this kernel
- Continuous integration of the kernel code
- Risks: Tends to grow, coordination overhead increases

**Customer/Supplier Development Teams**:
- Upstream prioritizes downstream needs in planning
- Downstream participates in acceptance tests
- Clear protocols for managing interface changes
- Example: Booking Context (customer) needs routing info from Transport Network Context (supplier)

**Conformist**:
- Eliminates translation complexity
- Constrains downstream design
- Use when: Upstream model is good enough, interface is large (translation would be huge)
- Don't use when: Upstream model is poor or incompatible with your needs

**Anti-Corruption Layer**:
- **Facade**: Simplified interface to the other system
- **Adapter**: Translates between protocols
- **Translator**: Converts between model concepts
- Example: Integrating with 20-year-old mainframe—build translation layer so new code never sees COBOL-era field names

**Separate Ways**:
- Integration has costs. Sometimes it's best to have no integration at all.
- Consider when: Integration provides limited benefit, complexity exceeds value
- The declaration that two contexts are going Separate Ways doesn't mean giving up—it means recognizing that forced integration would cost more than independent development

**Open Host Service**:
- Open protocol shared by multiple integrating systems
- Enhanced as needed for all users collectively
- One-off translators for special needs

**Published Language**:
- Well-documented shared language for domain information
- Examples: SWIFT for financial transactions, ACORD for insurance
- Benefits: Neutral ground for translation, established semantics reduce ambiguity

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

**The harsh reality**: Scarce, skilled developers often gravitate toward technical infrastructure or generic problems. The specialized Core often ends up with less skilled developers. Fight this tendency.

### Generic Subdomain Options

| Option | Advantages | Disadvantages |
|--------|-----------|---------------|
| **Off-the-shelf** | Less code, external maintenance | May not fit, integration overhead |
| **Published model** | Mature, documented | May need adaptation |
| **Outsourced** | Frees core team | Communication overhead |
| **In-house** | Exact fit | Ongoing maintenance |

**Key principle**: Don't let generic subdomains absorb your best talent.

---

## Distillation

Separating essential from non-essential, making Core Domain stand out.

**Core Domain Identification** — Ask: What's impossible to buy? What do experts get passionate about? What would cripple the business if done poorly?

### Domain Vision Statement

A short description (about one page) of the Core Domain and the value it brings.

**Contents**:
- Nature of the domain model
- How it is valuable to the enterprise
- How different interests are balanced

**What to include**:
- What makes this model special
- How it serves business needs
- Key distinctions from off-the-shelf solutions

**What NOT to include**:
- Technical architecture details
- Generic infrastructure concerns
- Features available in any competing product

**Use**: Guide resource allocation, inform modeling choices, educate team members.

### Highlighted Core

Make the Core Domain easy to see:

**Distillation Document**:
- 3-7 sparse pages
- Describes Core Domain and primary interactions
- Minimalist entry point, not complete design document
- Should age slowly (focuses on stable, high-level concepts)

**Flagged Core**:
- Mark Core elements within the primary model repository
- Use stereotypes, comments, or tools
- Make it effortless to know what's in or out

**As Process Tool**: When a code change requires updating the Distillation Document, that signals a significant change to the Core—consultation with the team is warranted.

### Other Distillation Patterns

**Cohesive Mechanisms** — Extract complex algorithms into separate modules. Mechanism does work, model uses mechanism.

*"A model proposes; a Cohesive Mechanism disposes."*

Distinction from Generic Subdomain:
- Generic Subdomain: An expressive model of domain concepts
- Cohesive Mechanism: Solves computational problems posed by the model

**Segregated Core** — Core in own module. Dependencies point inward. Non-core depends on core, not vice versa.

**Abstract Core** — Abstract model expressing the most fundamental concepts and relationships. Contains abstract classes or interfaces. Specialized aspects in separate Modules. References run toward the Abstract Core.

**Generic Extraction** — Move generic functionality out (auth, logging, notifications). Don't let it clutter Core.

---

## Large-Scale Structure

Patterns for organizing multiple Bounded Contexts and teams. Adopt only when natural fit emerges—don't force.

### Evolving Order

Let the structure evolve with the application, changing as needed.

**Key principles**:
- Don't impose structure prematurely
- Allow structure to grow organically
- Revisit and refine as understanding deepens
- A structure that doesn't fit should be discarded

**Avoid the Master Plan**: Overly ambitious up-front architecture becomes obsolete as requirements change, prevents organic adaptation, alienates developers who can't influence it.

### System Metaphor

A loose, easily understood analogy that provides vocabulary for large-scale structures.

**Benefits**: Easy to communicate, gives intuition about relationships, provides shared vocabulary.

**Examples**: "Desktop" for GUI file systems, "Shopping cart" for e-commerce, "Pipeline" for data processing.

**Risks**: May break down as the system grows, can be misleading if taken too literally, may constrain thinking.

### Responsibility Layers

Organizing the model into layers of conceptual responsibility, with dependencies running one way.

**Common layers (varies by domain)**:

| Layer | Responsibility | Examples |
|-------|---------------|----------|
| **Decision Support** | Analysis, planning, recommendations | Routing optimization, risk analysis |
| **Policy** | Rules, goals, constraints | Business rules, regulatory requirements |
| **Operations** | Current activities, state | Orders, shipments, transactions |
| **Potential/Capability** | What's possible | Resources, inventory, schedules |

**Rules**:
- Upper layers depend on lower layers
- Lower layers have no knowledge of upper layers
- Each layer has clear responsibilities

**Example: Cargo Shipping Layers**:
```
[Decision Support]  - Router, Route Bias Policy
         |
         v
[Operations]        - Cargo, Route Specification, Itinerary
         |
         v
[Capability]        - Customer, Transport Leg, Location
```

**Choosing Layers**: Look for storytelling (layers communicate domain priorities), conceptual dependency (upper layer concepts need lower layer backdrop), shearing planes (different rates of change between layers).

### Knowledge Level

A separate set of objects that describe and constrain the structure and behavior of the basic model.

**Use when**: Roles and relationships vary across situations, users need to configure object behavior, same code must support different business rules.

**Structure**:
- Knowledge Level: Describes types, rules, policies
- Operational Level: Objects that follow those rules

**Example: Employee Types**:
```
Operational Level:
  bob: Employee (references office_admin: EmployeeType)

Knowledge Level:
  office_admin: EmployeeType
    - payroll: HourlyPayroll
    - retirement: DefinedBenefit
```

The Knowledge Level (EmployeeType) constrains which retirement plans and payroll types an Employee can have.

**Caution**: Knowledge Levels add complexity. Use sparingly, only where configurability is crucial.

### Pluggable Component Framework

Abstract interfaces defining core concepts, allowing diverse implementations to be substituted.

**Characteristics**:
- Distilled Abstract Core as interfaces
- Hub that connects components through protocols
- Independent implementation of components

**Requirements**: Very mature domain understanding, deep stable model, precise interface design.

**Use sparingly**: Requires significant investment and may constrain future refinement.
