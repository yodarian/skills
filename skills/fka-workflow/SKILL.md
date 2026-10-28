---
name: fka-workflow
description: Find the next user-invoked phase in the fka workflow without automating its handoffs.
disable-model-invocation: true
---

# fka-workflow

Use this as an index when choosing the next fka skill. It routes by pointing to a phase; it never invokes another skill or performs its work. The canonical skill sources are under `skills/fka-*`; copy the needed directories into a target project's `.github/skills/` to make them discoverable there. Keep edits in the canonical sources.

## Route by work state

- Before a repo uses the workflow, start `fka-setup` to locate and fill gaps in context and module documentation.
- For an unclear or substantial feature with no confirmed outcome, start `fka-grill`.
- After the goal is confirmed, start `fka-impact` to discover legacy components. If you request a POC, start `fka-poc` and then rerun `fka-impact` on the original branch for detailed analysis and the refactoring gate.
- Start `fka-poc` only when you explicitly want an isolated experiment.
- For approved refactoring work, start `fka-tickets`, then `fka-implement` for each unblocked ticket. Start `fka-workflow` again after the refactoring tickets are complete.
- Once refactoring is not needed or is complete, start `fka-plan`, then `fka-tickets`, then `fka-implement` for feature work.
- Start `fka-review` separately whenever you want a review.
- For an existing SPIKE that needs a team-readable plan and decision matrix, start `fka-spike-plan`.
- For external research, explicitly start the research capability available in the target project; other fka phases use local repository evidence only.
- Use `fka-model` as a shared utility when a domain term needs sharpening or a durable architectural decision meets the ADR bar.

## Preserve the handoffs

Each workflow phase is started by the user; `fka-model` is the shared utility exception. Read `.scratch/<topic>/decisions.md` before recommending the next feature phase, and stop at any unresolved approval gate. Planning and ticketing do not start implementation; implementation does not commit or start another ticket automatically.

Completion: name the one next skill and the reason it is ready, or the precise decision/evidence still needed. Do not start that skill.
