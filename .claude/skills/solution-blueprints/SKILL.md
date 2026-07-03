---
name: solution-blueprints
description: Use when designing a solution, landing a technology choice, planning a complex feature, or when the user asks for "a plan" — first check whether a verified blueprint for the same class of task exists. Not for small changes with an obvious fix, pure bug fixes, or investigation tasks that produce no plan.
---

# Solution-Level Template Library

Collects solution blueprints verified in real projects. Each blueprint = steps +
acceptance criteria + risk points, so a lightweight model can apply it directly to
the same class of task instead of re-deriving it.

## Blueprints

**No entries yet.** (Library established 2026-07-03; no project has written back yet.)

## Admission bar (strictly enforced)

- Only plans that **landed and were verified in at least one project** are admitted;
  paper designs are rejected.
- Must name the source project + landing reference (PR link / commit range).
- Only cross-project-reusable skeletons are admitted; details bound to a single
  project are stripped or written back into that project.

Blueprint format:

```
### <blueprint name: what problem it solves>
- Applicability: what signals say to use this blueprint; what signals say not to
- Steps:
  1. … (each step states "do what + produces what", executable one by one)
- Acceptance criteria: what "complete" means for each key step (checkable output/command)
- Risk points: which step fails most easily, the failure symptoms, and the rollback action
- Verified in: <project + PR / commit range>
```

## Maintenance rules

- When a blueprint is applied a second time, write the new project's deltas back into
  "Applicability" or "Risk points" — a blueprint's value grows with verification count.
- A blueprint that fails when applied is not deleted: record the failure scenario in
  the entry and narrow its applicability; if thoroughly disproven, move it into
  [arch-constraints](../arch-constraints/SKILL.md).
