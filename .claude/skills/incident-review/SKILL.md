---
name: incident-review
description: Use when handling a production incident, performing a rollback/hotfix, or archiving lessons after fixing a costly bug (more than half a day to diagnose); also consult before executing high-risk changes to check for prior offenses of the same kind. Not for routine development without an incident, small bugs diagnosed within minutes, or first-time feature implementation.
---

# Cross-Project Incident Library

Collects incidents and high-cost bugs from any project, so every future project can
consult them before acting.

## Incident records

**No entries yet.** (Library established 2026-07-03; no project has written back yet.)

## Admission bar (strictly enforced)

- Every record must name the **source project + a traceable reference** (fix commit
  hash, PR/issue link). Anecdotes without provenance must not be written.
- Only incidents that "could recur in a different project" are admitted; incidents
  specific to a single project go back into that project's own `.claude/skills/`.
- "Symptom" records observed facts, not guesses; "root cause" must be a conclusion
  verified by the fix.

Entry format:

```
### <date> <one-line symptom>
- Project: <name / repo URL>
- Symptom: what the user/system observed
- Root cause:
- Fix: <commit hash or PR link> (if rolled back, include the reverted commit)
- Prevention: the general rule this produced, and which file in this library it landed in
  (risky operations → ../danger-ops/SKILL.md; approach bans → ../arch-constraints/SKILL.md;
   new gates → ../acceptance-bar/SKILL.md; misleading errors → ../debugging-playbook/SKILL.md)
```

## Maintenance rules

- Every incident must produce at least one "prevention" rule, landed in the matching
  skill file — a record that archives without producing a rule is invalid.
- When the same root cause recurs in a different project, escalate: examine why the
  previous prevention rule failed to catch it.
