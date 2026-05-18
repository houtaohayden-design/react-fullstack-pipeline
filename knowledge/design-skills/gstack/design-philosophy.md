# Design Philosophy -- gstack (Garry Tan's Design Methodology)

## Source
Derived from `DESIGN.md` and `ETHOS.md` in the gstack repository (github.com/garrytan/gstack).

---

## Core Design Beliefs

### 1. Completeness Is Cheap -- Do the Complete Thing
AI-assisted coding makes the marginal cost of completeness near-zero. When the complete implementation costs minutes more than the shortcut, always do the complete thing. This applies to design too: design every state (loading, empty, error, edge cases), not just the ideal path. A "boil the lake" approach means design systems should cover all component states, not just happy-path screens.

### 2. Coherence Over Individual Choices
A design system where every piece reinforces every other piece beats a system with individually "optimal" but mismatched choices. Typography choices should echo the aesthetic direction. Spacing density should match the product type. Motion level should pair with decoration level. The agent must check for coherence mismatches: brutalist aesthetic + expressive motion, expressive color + restrained decoration, creative-editorial layout + data-heavy product.

### 3. Taste Is Demonstrated Preference, Not a Constraint
Design taste emerges from what users have actually approved in prior sessions (persistent taste profile with confidence scores that decay 5% per week). The profile reflects demonstrated preference, not a constraint. Departure from it is valid when the product direction demands it, but must be stated explicitly and connected to the memorable-thing answer.

### 4. Propose, Don't Present Menus
The agent acts as a design consultant, not a form wizard. Make opinionated recommendations based on product context, then let the user adjust. Every recommendation needs a rationale: "because Y." Accept the user's final choice even when the agent disagrees with it.

### 5. Anti-Convergence Is Mandatory
Across multiple generations in the same project, vary light/dark, fonts, and aesthetic directions. Never propose the same choices twice without explicit justification. Convergence across generations is slop. AI tools converge on the same defaults (Inter, Space Grotesk, purple gradients) -- gstack deliberately diverges.

---

## What "Good Design" Means in gstack's Framework

### The SAFE/RISK Breakdown
Design coherence is table stakes -- every product in a category can be coherent and still look identical. The real question is: where do you take creative risks?

- **Safe Choices (2-3):** Decisions that match category conventions. These keep you literate in your category. Users expect them.
- **Risks (2-3):** Deliberate departures from convention. Each risk must have: what it is, why it works, what you gain, what it costs. The risks are where your product becomes memorable.

### Design Quality Gates
A design is "good" when it passes these gates:
1. Coherence: all choices reinforce each other (aesthetic, typography, color, spacing, motion form one package)
2. Category literacy: the safe choices keep it recognizable in its space
3. Memorable differentiation: the risks give it its own face
4. Intentionality: every design element has a reason to exist (no leftover spacing, no accidental hierarchy)
5. Taste demonstration: the work shows real design thinking, not template output

### The Memorable-Thing Framework
Every design system is anchored by one memorable thing: the one thing someone should remember after seeing the product for the first time. It could be a feeling, a visual element, a claim, or a posture. Every subsequent design decision serves this memorable thing. Design that tries to be memorable for everything is memorable for nothing.

---

## Design Decision Principles

### Three-Layer Knowledge Model (from ETHOS.md)
When making design decisions, understand which layer you are operating in:

- **Layer 1 (Tried and True):** Standard design patterns -- navigation conventions, readable font stacks, accessible color ratios. Don't reinvent these.
- **Layer 2 (New and Popular):** Current design trends, blog posts, ecosystem direction. Scrutinize what you find. The crowd can be wrong about new things.
- **Layer 3 (First Principles):** Original observations derived from reasoning about YOUR specific product and users. Prize these above everything. Where does the conventional design approach fail YOUR product?

The best projects avoid mistakes (don't reinvent Layer 1) while making brilliant observations that are out of distribution (Layer 3).

### Search Before Designing
Before building any design system, research the competitive landscape:
1. Identify 5-10 products in the space
2. Visit 3-5 top sites and capture visual evidence (screenshots, snapshots)
3. Synthesize: what does every product in this category share? What's trending? Where is the gap to stand out?
4. Eureka check: is there a reason the category's visual language fails THIS product?

### Design Outside Voices
When available, run Codex and a Claude subagent as independent design voices in parallel. Synthesize areas of agreement and genuine divergences. Cross-model agreement is a strong signal, not a mandate. The user decides.

---

## The Role of Taste

### Taste as a Persistently Measured Signal
Taste is tracked across sessions through a persistent taste profile with confidence scoring:
- **Approved entries:** fonts, colors, layouts, aesthetics the user has liked
- **Rejected entries:** what the user has explicitly rejected
- **Confidence decay:** 5% per week of inactivity -- recent approvals matter more
- **Conflict handling:** when current request contradicts strong persistent signal, flag it and ask

### Blacklisted and Overused Conventions
gstack maintains explicit blacklists and overuse warnings:

**Font blacklist (never recommend):** Papyrus, Comic Sans, Lobster, Impact, Jokerman, Bleeding Cowboys, Permanent Marker, Bradley Hand, Brush Script, Hobo, Trajan, Raleway, Clash Display, Courier New (for body)

**Overused fonts (never as primary):** Inter, Roboto, Arial, Helvetica, Open Sans, Lato, Montserrat, Poppins, Space Grotesk

Space Grotesk is specifically called out because every AI design tool converges on it as "the safe alternative to Inter." That's the convergence trap.

### AI Slop Anti-Patterns (never recommend)
- Purple/violet gradients as default accent
- 3-column feature grid with icons in colored circles
- Centered everything with uniform spacing
- Uniform bubbly border-radius on all elements
- Gradient buttons as the primary CTA pattern
- Generic stock-photo-style hero sections
- `system-ui` / `-apple-system` as the primary display or body font (the "I gave up on typography" signal)
- "Built for X" / "Designed for Y" marketing copy patterns

---

## How gstack Approaches Visual Design Differently

### 1. Design as Conversation, Not Form
gstack's agents are design consultants, not form wizards. The posture is: "I propose a complete coherent system, explain why it works, and invite you to adjust. At any point you can just talk to me about any of this."

### 2. Design Systems as Source of Truth
Every project has a DESIGN.md file that is the authoritative source for all design decisions. All font choices, colors, spacing, and aesthetic direction are defined there. In QA mode, any code that doesn't match DESIGN.md is flagged. CLAUDE.md is updated to reference DESIGN.md.

### 3. AI-Generated Design Must Be Embarrassment-Free
The self-gate before presenting any AI-generated mockup: "Would a human designer be embarrassed to put their name on this?" If yes, discard and regenerate. Embarrassment triggers include: purple gradient hero, 3-column SaaS grid, centered-everything, Inter body text, generic stock-photo vibe, system-ui font, gradient CTA button, bubble-radius everything.

### 4. Design Knowledge, Not Just Rules
gstack embeds deep design knowledge categories:
- 10 aesthetic directions (Brutally Minimal through Industrial/Utilitarian)
- 3 decoration levels (minimal / intentional / expressive)
- 3 layout approaches (grid-disciplined / creative-editorial / hybrid)
- 3 color approaches (restrained / balanced / expressive)
- 3 motion approaches (minimal-functional / intentional / expressive)
- Curated font recommendations by purpose (Display/Hero, Body, Data/Tables, Code)

### 5. Design Artifacts as User Data
All design artifacts (mockups, comparison boards, approved.json) are saved to `~/.gstack/projects/{slug}/designs/` -- never to project-local directories. Design artifacts are USER data, not project files. They persist across branches, conversations, and workspaces.
