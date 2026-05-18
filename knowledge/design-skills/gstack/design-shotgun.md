# Design Shotgun -- Visual Design Exploration Through Rapid Variant Generation

## Source
Derived from `design-shotgun/SKILL.md` in the gstack repository (github.com/garrytan/gstack).

---

## Overview

The design-shotgun skill is a visual brainstorming tool that generates multiple AI design variants simultaneously, opens them side-by-side in the user's browser via a comparison board, collects structured feedback, and iterates until a direction is approved. It is standalone design exploration, runnable anytime during development.

The agent persona is a design brainstorming partner, not a reviewer. This is visual exploration, not evaluation.

---

## When to Use

Triggers include: "explore designs", "show me options", "design variants", "visual brainstorm", "I don't like how this looks", or any time the user describes a UI feature but hasn't seen what it could look like.

Proactively suggest when:
- The user describes UI features without visual references
- The user says "I don't like how this looks" (use the evolve path)
- Mid-development polish is needed
- A page or component needs a visual direction decision

---

## UX Principles (Applying Nielsen/Norman Research)

Before generating any design, the skill applies these UX principles as observed behavior, not preferences:

### The Three Laws of Usability
1. **Don't make me think.** Every page should be self-evident. If a user stops to think "What do I click?" the design has failed. Self-evident > self-explanatory > requires explanation.
2. **Clicks don't matter, thinking does.** Three mindless unambiguous clicks beat one click that requires thought. Each step should feel like an obvious choice.
3. **Omit, then omit again.** Get rid of half the words on each page, then half of what's left. Happy talk must die. Instructions must die.

### How Users Actually Behave (Observed, Not Preferred)
- **Users scan, don't read.** Design for scanning with visual hierarchy, clearly defined areas, headings, and highlighted key terms. Interfaces are billboards at 60 mph, not brochures.
- **Users satisfice.** They pick the first reasonable option, not the best. Make the right choice the most visible choice.
- **Users muddle through.** They don't figure out how things work. They wing it. Once they find something that works, they stick to it.
- **Users don't read instructions.** They dive in. Guidance must be brief, timely, and unavoidable.

### Billboard Design for Interfaces
- **Use conventions.** Logo top-left, nav top/left, search = magnifying glass. Don't innovate on navigation to be clever. Innovate when you KNOW you have a better idea.
- **Visual hierarchy is everything.** Related things visually grouped. Nested things visually contained. More important = more prominent. Everything starts as visual noise, guilty until proven innocent.
- **Make clickable things obviously clickable.** No relying on hover states for discoverability. Shape, location, and formatting must signal clickability without interaction.
- **Eliminate noise.** Three sources: too many competing elements (shouting), poor organization (disorganization), too much stuff (clutter). Fix by removal, not addition.
- **Clarity trumps consistency.** If making something significantly clearer requires making it slightly inconsistent, choose clarity.

### Navigation as Wayfinding
Navigation must always answer: What site is this? What page am I on? What are the major sections? What are my options? Where am I? How can I search? The "trunk test": cover everything except navigation. You should still know the site, page, and major sections.

### Mobile: Same Rules, Higher Stakes
Real estate is scarce but never sacrifice usability for space. Affordances must be VISIBLE (no hover-to-discover). Touch targets >= 44px minimum. Flat design can strip interactive signals. Prioritize ruthlessly.

---

## Step 0: Session Detection

Check for prior design exploration sessions. If previous approved.json files exist, display a summary and offer:
- Revisit: reopen the comparison board to adjust choices
- New exploration: start fresh
- Something else

If first time, explain the premise: "This is /design-shotgun -- your visual brainstorming tool. I'll generate multiple AI design directions, open them side-by-side in your browser, and you pick your favorite."

---

## Step 1: Context Gathering (5 Dimensions)

1. **Who** -- persona, audience, expertise level
2. **Job to be done** -- what is the user trying to accomplish?
3. **What exists** -- existing components, pages, patterns in the codebase
4. **User flow** -- how do users arrive and where do they go next?
5. **Edge cases** -- long names, zero results, error states, mobile, first-time vs power user

Auto-gather first from DESIGN.md, source directory structure, and office-hours output. Then ask for what's missing in one comprehensive question. Two rounds max of context gathering.

If a local dev server is running AND the user said "I don't like how this looks," take a screenshot of the current page and use the evolve path instead of the variants path.

---

## Step 2: Taste Memory

Before generating variants, read the user's persistent taste profile and prior approved designs to bias generation toward demonstrated taste:

- **Persistent taste profile** (`~/.gstack/projects/{slug}/taste-profile.json`): tracks approved/rejected fonts, colors, layouts, aesthetics across sessions with confidence scores
- **Per-session approved.json files**: specific recent approvals
- Confidence decays 5% per week. Recent approvals matter more.
- If current request contradicts strong persistent signals, flag it: "Your taste profile strongly prefers X. You're asking for Y this time -- want to update the profile or treat this as a one-off?"

---

## Step 3: Generate Variants

### Step 3a: Concept Generation
Before any API calls, generate N text concepts describing each variant's distinct creative direction. Not minor variations -- each should feel like it came from a different design team.

```
I'll explore 3 directions:

A) "Name" -- one-line visual description
B) "Name" -- one-line visual description
C) "Name" -- one-line visual description
```

**Anti-convergence directive (hard requirement):** Each variant MUST use a different font family, color palette, and layout approach. If two variants could swap headline text without noticing, they're too similar. Concrete test: if variants look like three design teams' output, not one team at different coffee levels.

### Step 3b: Concept Confirmation
Confirm before spending API credits. Options: generate all, change concepts, add more variants, generate fewer variants. Max 2 rounds of refinement.

### Step 3c: Parallel Generation
Launch N subagents simultaneously (one per variant). Each agent independently:
1. Runs the design binary to generate its variant image
2. Handles rate limit retries (3 attempts with 5-second waits)
3. Copies the result from /tmp (sandbox workaround) to the design directory
4. Runs quality check against the brief
5. Reports success/failure

Critical path: always generate to `/tmp/` first, then `cp` to the final directory. Direct generation to `~/.gstack/...` can fail with sandbox errors.

**Evolve path:** When the user said "I don't like THIS," use `$D evolve --screenshot current.png --brief "..."` instead of `$D variants --brief "..."` to generate improvement variants from the existing design.

### Step 3d: Results
After all agents complete:
1. Show each variant PNG inline for immediate terminal viewing
2. Report success/failure counts with explicit errors
3. If zero variants succeeded: fall back to sequential generation
4. Construct dynamic image list from whatever files actually exist (not hardcoded A/B/C)

---

## Step 4: Comparison Board and Feedback Loop

### Board Generation
Create a comparison board HTML page and serve it over HTTP. The board:
- Shows all variants side-by-side
- Has a rating system (1-5 stars)
- Has per-variant comment fields
- Has an overall feedback field
- Has "Submit" (finalize) and "Regenerate/Remix" buttons
- Supports remixing: "layout from variant A, colors from variant B"

### Primary Wait
Use AskUserQuestion as the blocking mechanism to wait for user feedback. Do NOT ask which variant they prefer -- the comparison board IS the chooser. Include the board URL in the message.

### Feedback Processing
The board writes structured JSON:
```json
{
  "preferred": "A",
  "ratings": { "A": 4, "B": 3, "C": 2 },
  "comments": { "A": "Love the spacing" },
  "overall": "Go with A, bigger CTA",
  "regenerated": false
}
```

**If Submit received:** Read preferred variant, ratings, comments, overall direction. Proceed with the approved variant.

**If Regenerate/Remix received:** Read the action ("different", "match", "more_like_B", "remix") and optional remixSpec. Generate new variants with updated brief. Create new board. Reload in the browser. Repeat until Submit.

**If no feedback file:** The user typed preferences directly in the AskUserQuestion response. Use that text as feedback.

### Before Proceeding
Always confirm: "Here's what I understood from your feedback. Is this right?" before saving.

---

## Step 5: Feedback Confirmation

Output a clear summary:
```
PREFERRED: Variant [X]
RATINGS: A: 4/5, B: 3/5, C: 2/5
YOUR NOTES: [full comments]
DIRECTION: [direction]
```

Use AskUserQuestion to confirm before saving.

---

## Step 6: Save and Next Steps

Write `approved.json` to the design directory. Update the persistent taste profile with the approval.

If invoked from another skill (design-consultation, plan-design-review): return structured feedback for the calling skill to consume.

If standalone, offer next steps:
- A) Iterate more -- refine with specific feedback
- B) Finalize -- generate production HTML/CSS
- C) Save to plan -- add as approved mockup reference
- D) Done -- will use later

---

## Integration With Design System

DESIGN.md is the default constraint. Unless the user says otherwise, all variants respect the project's existing design system. If the user explicitly wants to diverge: "I'll follow your lead, but won't diverge from DESIGN.md by default."

---

## Key Design Patterns for React Code Generation

### The Shotgun Approach
Instead of designing one version and iterating, generate 3+ radically different variants simultaneously and let the user pick the best elements. This is faster than sequential iteration because it front-loads exploration.

### The Evolve Path
When improving existing designs (vs starting fresh), use the screenshot-to-variant evolution flow. This preserves what works while exploring improvements.

### The Remix Pattern
Users don't have to pick one whole variant. They can remix: component layout from A, color palette from B, typography from C. The regenerate action supports partial remixes via `remixSpec`.

### Anti-Convergence in Practice
- Each variant must use a different font family
- Each variant must use a different color temperature/approach
- Each variant must use a different layout rhythm
- If swapping headline text between two variants wouldn't be noticeable, they're too similar

### Taste Memory as Persistent Signal
Approved designs compound into a taste profile that biases future generations. This means shotgun exploration gets smarter over time -- it learns what the user likes and avoids generating rejected patterns.
