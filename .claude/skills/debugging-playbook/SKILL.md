---
name: debugging-playbook
description: Use when hitting a runtime error, test failure, build failure, or behavior that contradicts expectations and the cause needs locating — first check whether the error is a known "misleading error". Not for new feature design, documentation-only changes, or routine development with no anomaly yet.
---

# Misleading Errors and Pitfalls

Collects cross-project-reproduced cases where "the error points at A, but the real
cause is B", turning half-day diagnoses into a single table lookup.

## Admission bar

An entry must satisfy at least one of the following, and must be reusable across
projects (project-specific ones go back into that project):

- A **misleading error**: the message points at A, the real cause is B (with the
  project + commit/issue where it was first hit)
- A **non-obvious observation point**: a log/state location the error itself does
  not reveal
- A **reproduction recipe**: a class of problem that once took over 30 minutes to
  reproduce

Entry format:

```
### <one-line symptom>
- Environment: <language/framework/OS scope where this applies>
- Surface error: paste the key lines (3 max)
- Real cause:
- Observation point: where the log/file/command is
- Provenance: <project + commit / issue / PR>
```

## Entries

### Cross-platform script line-ending anomalies
- Environment: Windows + git (core.autocrlf enabled by default)
- Surface error: shell scripts fail with `\r: command not found`; diff shows the whole
  file changed; hash checks mismatch
- Real cause: git performs LF→CRLF auto-conversion on Windows
- Observation point: `git config core.autocrlf`; inspect line-ending bytes with a hex view
- Provenance: getFable initial commit `5553931` — git conversion warnings at commit time

## Related

- If diagnosis cost exceeded half a day, archive it in
  [incident-review](../incident-review/SKILL.md).
