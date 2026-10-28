---
name: fka-implement
description: Implement one approved fka ticket tests-first, run the project's relevant checks, and suggest an English Conventional Commit message.
disable-model-invocation: true
---

# fka-implement

Implement one ticket from `.scratch/<topic>/tickets/refactoring/` or `.scratch/<topic>/tickets/feature/` at a time. Follow the ticket's tests-first checklist and use the project's documented conventions.

## Process

1. Read the ticket file. If any **blocked by** ticket is incomplete, stop and say so.
   Completion: the ticket is unblocked and its scope is clear.
2. Read the relevant project instructions and discover quality-check commands from maintained documentation, task-runner scripts, and configuration. Do not invent commands or rely on stale copies. If the right command or scope is ambiguous, ask the user.
   Completion: the applicable checks and their scope are known.
3. Work the checklist top to bottom, one item at a time. Keep tests-first order and check off completed items. If the change conflicts with approved decisions or the ticket, stop and raise it.
   Completion: every checklist item is done or explicitly blocked.
4. Run the ticket's targeted tests and applicable documented checks. Fix failures caused by the change; report unrelated existing failures separately.
   Completion: checks pass, or remaining failures are clearly reported with their cause or uncertainty.
5. Suggest an English Conventional Commit message (`type(scope): summary`). The user creates the commit.
   Completion: the suggested message accurately describes the ticket.
6. Tell the user that `fka-review` is available when they want an independent review. Do not invoke it automatically or move to another ticket unless asked.
   Completion: the user knows what is done and what they can start next.

Never create a commit. Do not treat implementation as approval to continue into another phase.

If implementing the ticket surfaces a fact that contradicts `decisions.md` or the ticket itself, stop and flag it to the user rather than silently deciding for them.
