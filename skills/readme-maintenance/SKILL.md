---
name: readme-maintenance
description: User-invoked support for creating and keeping README.md files accurate and current.
disable-model-invocation: true
---

Create or refresh a repository README so it stays short, developer-focused, and aligned with the repository’s current setup.

Policy:
- Keep `README.md` as an onboarding and local setup entrypoint.
- Use `docs/` for expanded or grouped material such as architecture, development workflows, testing, and maintenance.
- Keep the README locally accurate; if setup depends on commands or scripts defined outside this repo, document where they are defined.
- Verify every local command and file path in `README.md` still works, and ensure each docs link resolves to a real file.

## Steps

1. Audit the repository and existing README(s).
   - Read the current `README.md` if it exists.
   - Inspect repository metadata, scripts, config files, docs, and any build/test commands.
   - If important setup or make commands are referenced but not present in this repo, ask the user where those commands live or what they are called before searching elsewhere.
   - Note outdated, missing, or incorrect README sections.
   Completion criterion: you can state which README sections are current, which are stale or missing, and which repo sources the setup guidance should reflect.

2. Decide README scope using the guideline.
   - Keep only a short repo description and developer setup guidance in `README.md`.
   - Prefer README for onboarding and local setup; put architecture, process, and maintenance topics in `docs/`.
   - Plan any expanded material for `docs/` so the README stays concise.
   Completion criterion: you have a README outline limited to purpose and setup, plus a list of grouped topics for `docs/`.

3. Write or update `README.md`.
   - Follow the guideline for what belongs in README versus what should move to docs.
   - Include a short project description, developer setup instructions, a minimal run/test example, and links to deeper docs.
   Completion criterion: `README.md` contains only a concise description, setup, and developer links.

4. Move detailed content into `docs/`.
   - Create or update supporting docs for expanded guidance.
   - Group related material by category instead of expanding the README.
   Completion criterion: any non-essential or long-form guidance is offloaded to `docs/`, with README links pointing to the new files.

5. Validate the README and docs.
   - Verify every local command, file link, and referenced tool exists.
   - Confirm `README.md` links to real `docs/` files and those files contain the detailed guidance.
   Completion criterion: `README.md` is short and accurate, and every external link in it resolves to an existing documentation file.

6. Save the README and note the update.
   - Write changed files to disk.
   - Summarize what changed and where long-form guidance moved.
   Completion criterion: the workspace has the updated README and supporting docs, and the change is captured in a short summary.

## Reference

- Follow the policy stated above in this file.
- Keep the skill’s steps focused on execution, not on repeating policy rules.
