---
name: acceptance-bar
description: Use when a change is considered finished and about to be committed or pushed — walk through the universal definition of done; also use before starting work to estimate how many gates "done" requires. Not for exploratory/throwaway intermediate changes, pure investigation tasks, or sessions that produce no commits.
---

# Universal Definition of Done

The floor for "finished" in any project. Each project's own build/test/CI gates live
in that project's `.claude/skills/` or CLAUDE.md and **stack on top of** this list,
never replace it.

## Required gates

1. `git status --short` is clean — no forgotten files, no accidentally committed
   temp files or debug leftovers (console.log / print / commented-out blocks).
2. The project's declared test/build/lint commands have all been run and pass — if
   none are declared, check package.json scripts, Makefile, and CI config; if still
   none, state "not verified by tests" explicitly in the handoff note.
3. The commit message explains *why* the change was made, not just *what* changed.
4. If the change touches an operation category in [danger-ops](../danger-ops/SKILL.md),
   its pre-actions have been completed.

## Admission bar

- New gates must come from an actual escape: a case where something was "believed
  done" but wasn't, with project + reference (commit / incident-review entry).
- Textbook best practices are rejected — only checks proven by an escape to be
  "genuinely forgettable" are admitted.

Entry format:

```
### <gate name>
- Check: a directly executable one-liner or an unambiguous verification step
- What counts as pass / fail
- Origin: <project + commit / incident-review entry>
```

## Related

- Gate failed and the cause is unclear → [debugging-playbook](../debugging-playbook/SKILL.md)
