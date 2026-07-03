---
name: arch-constraints
description: Use when choosing technology, adding a new dependency, designing module boundaries, or planning a large refactor — check whether the plan repeats an approach already disproven by real failure. Not for local changes that leave structure intact, documentation changes, or bug fixes.
---

# Disproven Technical Approaches

Collects approaches **disproven by actual failure** in any project, preventing new
projects from walking the same dead ends.

## Ban list

**No entries yet.** (No ban has been written back to this skill yet; other skills
in the library do have entries.)

## Admission bar (strictly enforced)

Bans must be derived from **failure evidence**, never from taste or fashion:

- Acceptable evidence: a specific project's revert commit, an abandoned branch, a PR
  closed with a stated reason, or an incident record in
  [incident-review](../incident-review/SKILL.md).
- "The industry says it's bad" does not constitute a ban. Constraints without
  evidence are rejected.
- Only bans that hold across projects are admitted; ones bound to a single project's
  context go back into that project.

Entry format:

```
### Do not: <one-line ban>
- Scope: what kinds of projects/scenarios this holds for
- Why it was done originally: the reasonable motivation at the time
  (so successors don't dismiss predecessors as fools and repeat the mistake)
- How it failed:
- Evidence: <project + revert commit / abandoned branch / PR link>
- Exception: under what conditions this ban may be reopened for discussion
```

## Boundaries with other skills

- "Allowed, but requires pre-checks" → [danger-ops](../danger-ops/SKILL.md)
- "How to verify once done" → [acceptance-bar](../acceptance-bar/SKILL.md)
- This file only collects "do not do it at all".
