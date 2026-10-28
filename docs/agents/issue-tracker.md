# Issue tracker: Local markdown

Issues and specs for this repo live as markdown files in [.scratch](../../.scratch). No external issue tracker is required.

## Conventions

- **Create an issue**: create a new markdown file in `.scratch/<feature>/` with a descriptive name such as `issue-<slug>.md`.
- **Read an issue**: open the corresponding markdown file directly from the repository.
- **List issues**: scan the files in `.scratch/` and its subfolders for open work items.
- **Comment on an issue**: append a new section or note to the markdown file.
- **Close an issue**: update the file status to `closed` or move it to an `archive/` folder.

## File format

Use a simple structure like this:

```md
---
status: open
labels: []
---

# Title

## Summary

Describe the problem or request here.

## Acceptance criteria

- [ ] Criterion one
- [ ] Criterion two
```

## When a skill says "publish to the issue tracker"

Create or update the relevant markdown file in `.scratch/<feature>/`.

## When a skill says "fetch the relevant ticket"

Open the matching markdown file directly.

## Folder convention

- Use one folder per feature or initiative under `.scratch/`.
- Keep related notes, subtasks, and follow-ups in that folder.
- If a task is done, mark it as closed or move it to an archive folder.
