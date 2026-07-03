---
name: danger-ops
description: Use when about to execute a hard-to-undo operation — force push, reset --hard, bulk delete/rename, database migration, production change, release, or touching auth/payment code — check the pre-action list first. Not for read-only operations, ordinary add/commit/push, or local changes that can be undone at any time.
---

# Hard-to-Undo Operations Checklist

Collects operation categories that are hard to undo in any project, plus the
pre-actions required before executing them.
"Allowed, but must do X first" lives here; "do not do it at all" lives in
[arch-constraints](../arch-constraints/SKILL.md).

## Operations

### git force push / reset --hard / clean -f
- Danger: irreversibly discards commits or untracked files
- Pre-actions: run `git log --oneline -5` first to confirm what will be overwritten
  or dropped; when in doubt, tag or `git branch backup/<date>` before executing
- Provenance: generic git semantics (destructive by design), no incident evidence required

### Scripted bulk file deletion / renaming
- Danger: the blast radius is hard to fully estimate before execution
- Pre-actions: produce the complete affected-file list read-only and review it before
  executing; prefer commands with a dry-run mode
- Provenance: generic semantics

## Admission bar

- New entries must be **category-level** operations (valid across projects), with the
  project + reference of the first incident, or marked "generic semantics" (the
  operation is irreversible by definition, no incident evidence needed).
- Project-specific dangerous files/modules ("must run test X before touching this
  file") go into that project's own `.claude/skills/`, not this library.

Entry format:

```
### <operation category>
- Danger: what gets irreversibly broken
- Pre-actions: what must be completed before executing (checkable, executable)
- Provenance: <project + incident-review entry / commit>, or "generic semantics"
```

## Maintenance rules

- Whenever an [incident-review](../incident-review/SKILL.md) record stems from a class
  of operation, evaluate adding that category here.
