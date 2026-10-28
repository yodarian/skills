---
name: fka-grill
description: Reach a shared understanding of an unclear or substantial feature before technical analysis begins.
disable-model-invocation: true
---

# fka-grill

Clarify the desired outcome and scope. This is not a codebase-analysis or specification-writing phase.

## Establish the topic

Read relevant existing `.scratch/<topic>/` notes and the project's domain vocabulary. Use `fka-model` if a domain term needs sharpening. Reuse an existing topic folder when the work belongs to it; otherwise agree a short topic slug.

Completion: the topic is identified and existing work will not be overwritten.

## Reach shared understanding

Map the work as a design tree and ask questions in rounds. Each round covers the full frontier: decisions whose prerequisites are already settled. Number every question, give a recommendation, then wait for answers before asking the next round. Look up facts in the repository instead of asking the user to supply them.

Clarify the problem, desired outcome, scope, non-goals, constraints, and any unresolved user or team decisions. Keep technical implementation choices for later phases. The session ends only when the frontier is empty and the user confirms the shared understanding.

Completion: the user confirms a coherent goal and scope, with unresolved questions explicitly listed.

## Record the handoff

Create or update `.scratch/<topic>/decisions.md` without replacing unrelated existing notes:

```md
# <Topic> — decisions

## Status
understood

## Problem and desired outcome
<Confirmed outcome>

## Scope and non-goals
- <In scope or explicitly out of scope>

## Decisions
- <Confirmed decision>

## Open questions
- <Unresolved item, or "None">
```

Tell the user that `fka-impact` is the next separately started phase. Do not write a spec, inspect implementation details, create tickets, or change code.

Completion: the confirmed goal is saved in `decisions.md` and the next phase is clear.
