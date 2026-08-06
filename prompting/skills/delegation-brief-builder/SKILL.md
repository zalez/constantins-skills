---
name: delegation-brief-builder
license: BSD-3-Clause
description: Helps turn rough ideas into well-structured AI prompts using the Delegation Brief framework. Use this skill whenever the user describes a task they want help structuring, asks for help writing a prompt, says things like "help me brief this," "build me a prompt for," "I want to delegate this to AI," or describes a complex task and seems unsure how to get started. Also trigger when the user pastes a vague or underspecified prompt and asks to improve it. Works for any AI tool — the output is a portable, copy-paste-ready prompt.
---

# Delegation Brief Builder

Turn rough ideas into well-structured prompts. Detect whether the task needs a quick Intent Prompt or a full Delegation Brief, then help the user build it through conversation.

## Core principle

The framework is built on a single insight: **effective delegation transfers intent, not instructions.** Tell the AI what success looks like and why it matters, not what steps to take. This works because every intelligent agent — human or AI — performs better when it understands the purpose behind the task.

## Workflow

### 1. Understand the rough idea

The user will describe what they want to accomplish. This might be:
- A rough description ("I need to build a dashboard for...")
- A vague prompt they want improved ("Write me a report about...")
- A complex project they're about to kick off ("I'm starting a Claude Code session to...")

Read what they provide carefully. Note what's already covered and what's missing.

### 2. Detect scope

Assess whether this is a **simple task** or a **complex task**:

**Simple** — single output, tight feedback loop, user will review immediately. Examples: draft an email, rewrite a paragraph, summarize a document, write a short script.

**Complex** — multi-step, requires autonomous decisions, large scope, or the AI will run for a while without checking in. Examples: build an app, write a long document, perform a comprehensive analysis, produce a video script, create a full project.

When in doubt, lean toward complex — it's better to ask a few extra questions than to produce an underspecified prompt.

### 3a. Simple tasks → Intent Prompt

Reformulate the user's idea into a clear Intent Prompt with three components:

- **Intent**: A concrete end state and why it matters.
- **Next Step**: What the AI should do right now.
- **Approach** (if helpful): A brief suggestion on angle or method.

Present it and ask if they want to adjust before proceeding.

Read `references/building-blocks.md` for detailed guidance on writing strong intent statements.

### 3b. Complex tasks → Interview for Delegation Brief

Interview the user to fill in the building blocks they haven't already covered. Read `references/building-blocks.md` first — it contains the detailed description, purpose, and guiding questions for each block:

- **Intent** — the destination beacon
- **Context** — the terrain map
- **Deliverables** — the checkpoints
- **Navigation** (Tenets + Guardrails) — the compass and the fence
- **Toolbox** — the supply pack

#### Interview rules

- **Skip what's covered.** If the user's description already includes audience, constraints, or format, don't re-ask. Acknowledge what you've captured and focus on what's missing.
- **Group questions logically.** Ask 3–4 related questions at a time. Don't dump everything at once.
- **Be conversational.** This should feel like a smart colleague helping think through the task, not a bureaucratic intake form.
- **Suggest tenets proactively.** Based on what you learn, propose 2–3 specific tenets in "X over Y" form. Ask if they resonate. Read `references/example-tenets.md` for inspiration, but always tailor to the specific task.
- **2–3 rounds is usually enough.** Don't over-interview. A solid 80% brief with a note about what's missing beats an exhaustive one that wore the user out.

### 4. Assemble and present

Once you have enough information:

1. Assemble the complete prompt under clear building block headings.
2. Briefly note which blocks you included and why.
3. Flag anything you think is missing or worth revisiting.
4. Ask the user: should you execute the task directly, or hand over the prompt for them to use elsewhere?

### 5. Improving an existing prompt

If the user provides an existing prompt to improve rather than starting from scratch:

1. Map what's already there to the building blocks.
2. Identify gaps (usually: missing intent/why, no tenets, vague deliverables).
3. Ask focused questions to fill just the gaps.
4. Present the improved version alongside the original so the user can see what changed.
