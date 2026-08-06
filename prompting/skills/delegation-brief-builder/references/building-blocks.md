# Building blocks reference

Each building block exists because it answers a specific question the AI would otherwise have to guess at. The blocks build on each other: Intent is always required, the rest are added as scope and autonomy increase.

## Intent — the destination beacon

**What it is:** The concrete end state and why it matters. This is the one non-negotiable element — every prompt needs it, whether simple or complex.

**Why it exists:** Intelligent agents (human or AI) make better micro-decisions when they understand the purpose behind the task. "Write a professional email" gives the AI nothing to calibrate against. "Write a reply that signals support but flags the timeline risk, because I want to stay aligned without silently agreeing to an unrealistic deadline" gives it a finish line and a reason.

**What a good one includes:**
- A verifiable end state — something both you and the AI could check
- The "why" — the purpose, stakes, or context that shapes what "good" looks like
- Enough embedded context for simple tasks (audience, tone, constraints woven into the statement naturally)

**Guiding questions to ask the user:**
- "If you could only tell the AI one sentence about what you need, what would it be?"
- "Can you describe what 'done' looks like in a way you could both verify?"
- "Why does this matter? What's at stake?"

**When intent gets overloaded:** If the intent statement keeps growing because there's too much context to embed naturally, that's the signal to break it into separate building blocks (Context, Deliverables, etc.).

## Context — the terrain map

**What it is:** Everything the AI needs to not make contextually wrong decisions. Separated from Intent because it's too rich to embed in a single statement.

**Why it exists:** The AI's knowledge is a vast dark landscape. Context acts as illumination — it activates knowledge the AI already has ("my audience is skeptical CTOs") and provides knowledge it can't have (your specific data, constraints, history). Without it, the AI picks the most "average" path.

**What it might include:**
- Audience and stakeholders
- Existing work, prior decisions, what's been tried before
- Constraints (technical, political, social, budgetary)
- Landscape information that shapes what "good" looks like
- What the AI should know to avoid embarrassing mistakes

**Guiding question to ask the user:**
- "What would a smart new colleague need to know on their first day to not embarrass themselves on this project?"

## Deliverables — the checkpoints

**What it is:** Specific outputs, formats, and intermediate review points. Turns a vague mission into something verifiable.

**Why it exists:** Without explicit deliverables, the AI decides on its own what to produce, in what format, and whether to check in along the way. For complex tasks, this leads to unpleasant surprises ("I wanted an outline first, not a 3,000-word draft").

**What it might include:**
- Specific output format (document, code, outline, spreadsheet)
- Intermediate waypoints ("outline first, then full draft after my review")
- Quality criteria or acceptance conditions
- Length or scope constraints

**Guiding questions to ask the user:**
- "What do you want to receive, and when do you want to check in before the final result?"
- "Is there an intermediate step where you'd like to review before the AI continues?"

## Navigation — the compass and the fence

Navigation has two complementary instruments:

### Tenets (the compass)

**What they are:** Decision principles that tell the AI which way to go when facing a trade-off. They enable autonomous action by resolving recurring dilemmas without human intervention.

**Why they exist:** Every complex task involves dozens of micro-decisions. Should the AI be thorough or concise? Formal or casual? Should it optimize for speed or quality? Without tenets, it either guesses (often wrong) or interrupts to ask (slowing everything down). Tenets eliminate this by pre-resolving the trade-offs.

**The quality test (from Amazon):** A good tenet has a meaningful opposite. If nobody would argue the other side, it's not a tenet — it's a truism.

- ❌ "Produce high-quality output" — who would argue against this? It resolves nothing.
- ✅ "Concise over comprehensive" — someone could legitimately prefer the opposite. This resolves a real tension.

**Common forms:**
- "X over Y" — "Readable code over clever code"
- "A, not B" — "My voice, not AI-generic"
- Counter-intuitive beliefs — "Surface problems eagerly" (opposite: "Stay focused on the positive path forward")

**How to help users write them:**
- Suggest tenets proactively based on what you've learned about their task
- Use the "X over Y" form — it's the easiest to write and the clearest to interpret
- Test each one: "Could someone reasonably prefer the opposite?" If not, rephrase or drop it
- 3–5 tenets is usually the sweet spot

See `example-tenets.md` for a library of tenets organized by category.

### Guardrails (the fence)

**What they are:** Hard boundaries and escalation triggers. Non-negotiable constraints.

**Why they exist:** Tenets guide the AI toward good decisions. Guardrails prevent catastrophic ones. They define what's out of scope and when the AI must stop and check in rather than proceeding on its own.

**What they might include:**
- Hard constraints ("Don't exceed 12 minutes of script")
- Scope boundaries ("No external APIs or paid services")
- Escalation triggers ("If you're uncertain about a factual claim, flag it rather than guessing")
- Review checkpoints ("Stop after the outline for my review")

**Guiding questions to ask the user:**
- "What trade-offs will the AI face repeatedly, and which side should it come down on?" (tenets)
- "What would make you say 'you should have checked with me before doing that'?" (guardrails)

## Toolbox — the supply pack

**What it is:** Supporting materials that enhance any building block. Not a building block in its own right — it's a container for anything useful that doesn't fit elsewhere.

**Why it exists:** Examples, references, and resources dramatically improve output quality but don't belong in any single building block. The Toolbox is where they live.

**What it might include:**
- Examples of good and bad output
- Reference materials, links, data files
- Style guides or voice references
- Approach suggestions ("try a narrative structure")
- Random ideas, inspiration, brain dumps

**Guiding question to ask the user:**
- "Do you have examples, references, or materials that would help the AI get this right?"
