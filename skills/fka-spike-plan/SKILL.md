---
name: fka-spike-plan
description: Turn an existing SPIKE or technical question into a team-readable plan and decision matrix.
disable-model-invocation: true
---

# fka-spike-plan

Process an existing SPIKE or technical question. This skill does not create Jira issues or implement the proposed solution.

## Gather the SPIKE

Read the supplied SPIKE, relevant `.scratch/<topic>/` notes, and project context and ADRs. Clarify the question the team must answer, the decision owner, and any constraints. Keep local codebase analysis in scope; external research is only done when the user explicitly starts a research activity and supplies or requests that work.

Completion: the decision question, scope, and known constraints are explicit.

## Compare options

Identify viable options and compare them against explicit criteria. Include trade-offs, pros and cons, risks, open questions, and a reasoned recommendation. Separate repository facts from assumptions. The recommendation informs the team but does not make the decision.

Completion: the matrix covers the viable options and the criteria that distinguish them; unknowns are visible.

## Write the proposal

Create or update these files under `.scratch/<topic>/`:

- `decision-matrix.md`: the question, criteria, options, trade-offs, open questions, and recommendation.
- `plan.md`: context, desired outcome, proposed approach, sequence, dependencies, risks, and pending team decisions.

Mark the plan as a proposal while decisions remain open. After the user provides the team's decisions, update both files to identify the selected option and the resulting plan. Do not invent team approval. If the confirmed outcome changes durable domain language or makes a lasting architectural choice, use `fka-model`.

Completion: the plan is either clearly pending team agreement or updated to reflect the decision the user reported. Tell the user which decisions or follow-up work remain; do not create agent tickets automatically.
