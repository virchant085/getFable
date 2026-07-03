# getFable — Cross-Project Engineering Experience Library

This repository is not a code project; it is an **experience-asset store**: the skill
documents under `.claude/skills/` are mirrored by `sync.ps1` into `~/.claude/skills/`
and take effect globally across all of the user's projects.
Working in this repository = writing and maintaining these skill documents.

## Hard writing constraints

1. **Admission test: would this still hold in a different project?** If not, do not
   admit it — direct it back into the source project's own `.claude/skills/`.
2. **Every entry must carry a provenance reference**: source project name + a traceable
   credential (commit hash, PR/issue link, or file path). Anecdotes without provenance
   must not be written. Two codified exemptions: entries marked "generic semantics"
   (operations irreversible by definition, e.g. in danger-ops), and founding-floor
   content explicitly labeled as such (acceptance-bar's Required gates).
3. Skill body ≤300 lines; textbook methodology is excluded — only judgments verified
   in practice are admitted.
4. The frontmatter `description` must state both the trigger condition ("Use when…")
   and the exclusion cases ("Not for…"), and must not contain "this project / this
   repo" wording — these skills trigger in arbitrary projects.
5. Skills reference each other via relative paths; copying content is forbidden.
6. After every skill change: run `.\sync.ps1` to mirror globally, then commit + push.
7. `.claude/settings.local.json` stays out of the repo (already in .gitignore).
8. `main` is the only long-lived branch; remote is github.com/virchant085/getFable.

## Three-way cross review

After roughly every 10 new entries, run the following in three **fresh** sessions
(never the session that generated the entries):

- **Fact check**: verify each provenance reference exists and the description matches
  the actual commit/PR. Output: document location + claimed content + actual evidence
  + verdict (wrong / stale / unverifiable).
- **Logic check**: read all skills end to end; find mutually contradictory rules,
  circular references, and references to non-existent documents.
- **Trigger check**: look only at each `description`; simulate whether a lightweight
  model would load it at the right moment in "fixing a bug / adding a feature /
  running a risky operation / finalizing a commit" scenarios. Flag triggers that are
  too broad, too narrow, or overlapping, and propose rewrites.

## Skill index

- [incident-review](.claude/skills/incident-review/SKILL.md) — cross-project incident library
- [debugging-playbook](.claude/skills/debugging-playbook/SKILL.md) — misleading errors and pitfalls
- [arch-constraints](.claude/skills/arch-constraints/SKILL.md) — disproven technical approaches
- [danger-ops](.claude/skills/danger-ops/SKILL.md) — hard-to-undo operations checklist
- [acceptance-bar](.claude/skills/acceptance-bar/SKILL.md) — universal definition of done
- [solution-blueprints](.claude/skills/solution-blueprints/SKILL.md) — solution-level template library
