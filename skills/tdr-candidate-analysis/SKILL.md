---
name: tdr-candidate-analysis
description: Help the user identify candidate classes for Technical Debt Reports and prepare them for creation; do not create TDRs until the user selects candidates.
disable-model-invocation: true
---

This skill inspects a class and identifies one or more candidate Technical Debt Reports (TDRs) using the agreed template in `TDR-TEMPLATE.md`. It does not create TDR files until the user confirms selected candidates.

## Steps

1. Understand the user's target class and the existing TDR template.
   - Ask the user which class or classes they want analyzed.
   - Confirm the existing TDR template and locate it in the workspace.
   Completion criterion: you have a concrete target class and the agreed TDR template reference needed to draft candidates.

2. Inspect the target class for debt indicators.
   - Read the class implementation and any nearby tests or documentation.
   - Look for common technical debt signals: large/mixed responsibilities, duplicated or hard-to-follow logic, missing tests, poor naming, unclear boundaries, excessive coupling, or brittle control flow.
   - Identify any candidate debt types that fit the user's template fields.
   Completion criterion: you have a list of candidate debt findings tied to the actual class code and template fields.

3. Generate candidate TDR entries without creating files.
   - For each finding, produce a candidate summary describing the debt, the reason it matters, and the scope of the change.
   - Map each candidate to the chosen template fields and include any options for splitting or combining candidates.
   - Keep the output as a candidate list, not a final file creation step.
   Completion criterion: the user can clearly review each candidate and choose which ones should become actual TDRs.

4. Present candidates and ask for selection.
   - Show the candidate list with enough detail for an informed decision.
   - Ask the user to confirm one or more candidates to create as TDRs.
   Completion criterion: the user has selected at least one candidate or asked for more refinement.

5. Create TDRs only after user approval.
   - If the user selects candidates, create TDR files using the agreed template and candidate content.
   - If the user does not select any candidates, stop and offer further refinement.
   Completion criterion: TDR files are created only for approved candidates, otherwise no files are written.

## Reference

- A candidate is a potential TDR that captures a concrete area of technical debt in the inspected class.
- Do not assume the template is fixed until the user confirms it.
- Keep the initial run strictly candidate-focused; avoid jumping to file creation before approval.
