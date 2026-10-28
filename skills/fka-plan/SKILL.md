---
name: fka-plan
description: Shape an approved feature into small, reviewable implementation slices after codebase impact and any approved refactoring are complete.
disable-model-invocation: true
---

# fka-plan

Plan feature slices only after `fka-grill` and `fka-impact`. This phase does not reopen the problem interview, inspect the codebase in depth, or write ticket files.

## Entry gate

Read `.scratch/<topic>/decisions.md` and the relevant project context and ADRs.

- Require a user-confirmed goal and a completed codebase-impact section.
- If refactoring was approved, require evidence that its tickets are complete before planning feature work. If it is pending or incomplete, stop and name the next skill or decision needed.
- If refactoring was declined or none is needed, continue.

Completion: the feature is eligible for planning and the intended behavior is clear enough to slice.

## Shape the slices

Work in short rounds when a design choice is unsettled. Recommend small vertical slices with observable behavior and clear acceptance criteria. Use separate, reviewable technical-preparation slices where needed; keep approved refactoring separate from feature work.

For every slice, identify:

- the user-visible or otherwise observable behavior it makes true
- acceptance criteria and behavior tests, ordered tests-first
- technical prerequisites and dependencies
- a diff small enough for focused review and a Conventional Commit

Use the project's vocabulary and documented coding and architecture conventions. If a durable domain term or architectural trade-off needs recording, use `fka-model`.

Completion: the user has approved an ordered slice plan, including dependencies and the test intent for each slice.

## Record the plan

Append the approved outline under `## Feature slices` in `.scratch/<topic>/decisions.md`. Keep it concise; this is a handoff for `fka-tickets`, not a full human-facing feature specification.

Do not create tickets or start implementation in this phase. Tell the user to start `fka-tickets` separately.

Completion: the approved slice outline is recorded in `decisions.md` and the ticketing handoff is clear.
