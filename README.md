# getFable — Cross-Project Engineering Experience Library

Distills high-level outputs from Claude Fable 5 sessions (hard-bug root causes,
disproven approaches, reusable solution blueprints) into structured skill documents,
synced to the global `~/.claude/skills/` so that lightweight models (Opus 4.8 etc.)
can automatically trigger and reuse them in **every project**.

## Workflow

```
Fable 5 solves a hard problem (in any project)
        │
        ▼
Ask: would this still hold in a different project?
        │ yes                         │ no
        ▼                             ▼
Write one entry into the        Write it back into that project's
matching skill in this repo     own .claude/skills/
        │
        ▼
Run .\sync.ps1 → mirror to ~/.claude/skills/ (takes effect globally)
        │
        ▼
git commit + push (experience assets are versioned and revertible)
```

## Skill catalog

| Skill | What it collects | Entries |
|---|---|---|
| [incident-review](.claude/skills/incident-review/SKILL.md) | Cross-project incident retrospectives: symptom + root cause + fix reference + prevention rule | 0 |
| [debugging-playbook](.claude/skills/debugging-playbook/SKILL.md) | Misleading errors and pitfalls: the error points at A, the real cause is B | 6 |
| [arch-constraints](.claude/skills/arch-constraints/SKILL.md) | Technical approaches disproven by real-world failure | 0 |
| [danger-ops](.claude/skills/danger-ops/SKILL.md) | Hard-to-undo operations and their required pre-checks | 3 (2 generic + 1 sourced) |
| [acceptance-bar](.claude/skills/acceptance-bar/SKILL.md) | Universal definition of done: what counts as finished | 1 |
| [solution-blueprints](.claude/skills/solution-blueprints/SKILL.md) | Solution-level templates: steps + acceptance criteria + risk points | 3 |

Current source projects: `virchant_wei_Page` (6 debugging-playbook pitfalls; 3 solution
blueprints — ADR re-verification → implementation plan, plan → GitHub issue backlog,
supervised slice execution; 1 danger-ops category — agent-framework `init` into an
existing repo; 1 acceptance-bar gate — environment-stated evidence).

## Maintenance cadence

- **Write-back**: before ending a Fable 5 session, add one line: "Write back any
  cross-project-reusable experience from this session into the matching skill in
  D:\getFable, following its CLAUDE.md writing rules."
- **Review**: after roughly every 10 new entries, run the three-way cross review
  (facts / logic / trigger conditions) in three fresh sessions — prompts are in
  [CLAUDE.md](CLAUDE.md#three-way-cross-review). Currently 11 entries written back —
  **the ~10-entry review threshold is reached: run the three-way cross review (facts / logic / triggers) in three fresh sessions before the next write-back.**
- **Conflicts**: if a project defines a skill with the same name, the project-level
  skill wins; rename the skill in this library to step aside.
