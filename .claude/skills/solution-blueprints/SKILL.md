---
name: solution-blueprints
description: Use when producing a written plan or design — a multi-day or multi-module feature, a technology choice, a system design, or whenever the user explicitly asks for "a plan" — first check whether a verified blueprint for the same class of task exists. Not for routine features a competent developer would implement without a written plan, small changes with an obvious fix, pure bug fixes, or investigation tasks that produce no plan.
---

# Solution-Level Template Library

Collects solution blueprints verified in real projects. Each blueprint = steps +
acceptance criteria + risk points, so a lightweight model can apply it directly to
the same class of task instead of re-deriving it.

## Blueprints

### Phase-kickoff ADR re-verification → implementation plan
- Applicability: a project is about to start a phase whose stack was decided in ADRs
  weeks/months earlier, and those ADRs carry "re-verify at kickoff" triggers
  (versions, pricing, vendor health, known bugs). Strong signals: fast-moving vendors
  (auth/DB/payments SaaS), date-pinned facts, stale-tutorial risk. Not for: greenfield
  choices with no prior ADRs (that is ordinary research), or a single dependency bump.
- Steps:
  1. Read all ADRs + the code seams they promised; extract each ADR's review triggers
     → produces the research track list: one track per decision layer, **plus one
     integration-seams track** covering the joints between products (middleware
     composition, adapters, preview/CI environments, email, testing).
  2. Run the tracks in parallel; each outputs: verdict (HOLDS / CHANGED /
     NEEDS-DECISION), exact version pins, facts each with a primary-source URL,
     risks, recommendations, and 3–5 **gating claims phrased as single checkable
     factual statements**.
  3. Adversarially verify every gating claim with an independent fresh agent
     instructed to REFUTE it using primary sources it fetches itself (npm registry
     JSON, GitHub issue state, official pricing pages) → CONFIRMED /
     REFUTED(+correction) / UNCERTAIN.
  4. Run a completeness critic over all verified findings — "what did nobody ask?" —
     aimed at ops, compliance, platform ToS, cost ceilings, data lifecycle
     (deletion/expiry/reconciliation), and i18n × the new subsystem.
  5. Synthesize the plan: ADR-verdict table; owner-decision table ordered by
     what-blocks-what (separating "blocks development" from "blocks go-live");
     version-pin table; implementation slices each with acceptance criteria +
     rollback.
  6. Adversarially review the synthesized plan with fresh multi-lens agents
     (security-rules compliance / repo-and-docs consistency / solo-dev pragmatism),
     then fold the verdicts into a v2.
- Acceptance criteria: every load-bearing claim carries a verdict + primary source;
  the plan names exact pins, not ranges; each slice is one mergeable/revertable PR;
  the decision table distinguishes dev-blocking from go-live-blocking; step 4's
  completeness critique produced recorded findings (or an explicit zero-findings
  verdict); step 6 produced concrete findings (a zero-finding review of a v1 plan
  is a red flag, not a pass).
- Risk points: (1) research agents sound authoritative but are ~5% wrong — in the
  source run 1 of 20 verified claims was REFUTED (a product's GA status); skipping
  step 3 ships that error into the plan. (2) The completeness critic found the single
  highest-value gap (the hosting plan's ToS forbids commercial use) that all four
  specialist tracks missed — do not skip step 4. (3) Step 6's fresh lenses caught a
  deploy/migration race and an oversized slice that the synthesizing context could
  not see in its own work — synthesis inherits research blind spots; plan reviewers
  must be fresh agents. (4) Long multi-agent runs can die on session/rate limits
  mid-verification — use resumable orchestration (completed steps cached) so research
  is never re-paid.
- Verified in: virchant_wei_Page, 2026-07-03 — process executed end-to-end
  (4 research tracks + 20 adversarial claim verifications + completeness critic +
  3-lens plan review) producing `docs/p2-plan.md` v2; plan execution has begun —
  slices S0/S1 landed and closed (issues #23/#24, commits `86c328f`…`f0b9029`,
  CI green), remaining P2 slices pending

### Implementation plan → dependency-linked GitHub issue backlog
- Applicability: a reviewed implementation plan exists (slices/phases with acceptance
  criteria) and work must become independently pickup-able by AFK agents or future
  sessions with zero conversation memory. Not for: exploratory work without a plan,
  or a 2–3-task list a single session will finish anyway.
- Steps:
  1. Split the plan into three issue kinds: **owner-decision issues** (one per
     pending decision, `ready-for-human`, stating options/recommendation/what it
     blocks and separating dev-blocking from go-live-blocking), **slice issues**
     (one per independently mergeable+revertible PR, `ready-for-agent`, with
     file-path-level tasks, mechanically checkable acceptance, rollback line), and
     one **tracking board** (dependency graph + execution order + decision table).
  2. Draft everything in ONE delimited file with `{{KEY}}` cross-reference tokens;
     a parser script validates blocks/labels/refs via `--dry` before anything is
     filed.
  3. Inside agent-labeled issues, demarcate owner-only steps as an explicit
     "Owner pre-steps" section (registrar/DB-console/payment-org/purchases) so an
     AFK dispatch knows what is not its job.
  4. Adversarially review the draft with fresh agents before filing — two lenses:
     **fidelity-diff against the source plan** (every task lands exactly once,
     nothing invented, dependencies match) and **AFK-executability** (self-contained,
     checkable acceptance, correct labels, one-PR-sized).
  5. File two-pass: create all issues capturing numbers, then edit bodies replacing
     `{{KEY}}` with `#N` — this resolves forward references (decision issues citing
     slice issues) that single-pass creation cannot.
  6. Verify a filed issue renders with live links + milestone, then check off the
     backlog item in the project's ledger.
- Acceptance criteria: `--dry` passes (all refs resolve, labels exist in the repo —
  `gh issue create --label` hard-fails on unknown labels); every cross-reference in
  filed issues is a clickable `#N`; each slice issue is executable from its body plus
  the referenced plan section alone; the tracking board's graph matches the issue
  bodies' blocked-by lines; the step-4 fidelity + AFK-executability review ran before
  filing, with findings (or an explicit zero-findings verdict) recorded.
- Risk points: (1) **transcription drift is the killer** — converting plan→issues by
  the same context that holds the plan produced 21 review findings including a HIGH
  rule *inversion* (draft said "start on v1 if GA" where the plan said "pin 0.45.x,
  spike later"), plus invented citations and invented parallelism; the fidelity lens
  is not optional. (2) Filing is outward-facing — create labels/milestone before the
  run, review before filing, because mass-editing filed issues is noisy. (3) Watch
  label semantics: tracking boards don't get `needs-triage`, record-only decisions
  don't get `ready-for-human`.
- Verified in: virchant_wei_Page — issues #14–#32 on milestone "P2 — Auth · DB ·
  Payments · Go-live", ledger commit `f12a0ce` (2026-07-03)

### Supervised slice execution: executor/supervisor split with first-hand re-verification
- Applicability: issue-driven implementation where one agent (or person) executes a
  well-specified work order and a second context supervises quality before anything
  lands. Worth the overhead when the change touches infrastructure, security, or
  anything whose verification is environment-sensitive. Not for: trivial edits, or
  when no second context is available (then self-review against the same checklist).
- Steps:
  1. Dispatch with a contract: the executor reads the issue + spec + house rules,
     IMPLEMENTS and VERIFIES, but does NOT commit/push/close — the working tree is
     the handoff. Require a structured report: FILES / EVIDENCE-per-DoD-item /
     DECISIONS / CONCERNS.
  2. Supervisor verifies the file list matches the report (`git status`), then
     RE-RUNS every quality gate first-hand — never adjudicate from the report alone.
  3. Spot-read the critical code (boundaries, fail-closed paths, config files) and
     hunt for claims that contradict the code (an eager parse claimed lazy, an
     "offline" command that reads credentials).
  4. Adjudicate each reported CONCERN explicitly — accept / reject / defer with a
     recorded rationale; concerns the executor surfaces honestly are where the real
     architectural decisions hide.
  5. Return work with REPRODUCED findings only (the failing command + output, the
     required fix, the re-verification list) — not vibes. The executor resumes with
     its context intact and reports deltas.
  6. Supervisor commits in logical units, watches CI live (a new CI job is unproven
     until its first real run), and closes the issue distinguishing
     supervisor-verified evidence from executor-reported evidence.
- Acceptance criteria: every gate in the close-out was re-run by the supervisor;
  every returned finding carried a reproduction; concerns have recorded verdicts;
  CI observed green live (not assumed from local runs).
- Risk points: (1) executor evidence can be environment-contaminated — the source
  run's executor claimed a clean-env success that had inherited test placeholders
  (see the [acceptance-bar](../acceptance-bar/SKILL.md) "environment-stated evidence"
  gate); (2) new CI jobs pass YAML
  validation and still fail their first live run (driver/servics mismatches only
  the real runner exposes) — budget a fix round after the first push; (3) the
  supervisor rubber-stamping the report instead of re-running gates collapses the
  whole pattern into ceremony.
- Verified in: virchant_wei_Page issues #23 + #24 (commits `86c328f`…`f0b9029`,
  2026-07-03/04) — two slices, two supervisor-caught defects (a false clean-env
  claim; a CI driver incompatibility), both fixed by the resumed executor

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
