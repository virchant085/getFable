---
name: solution-blueprints
description: Use when designing a solution, landing a technology choice, planning a complex feature, or when the user asks for "a plan" — first check whether a verified blueprint for the same class of task exists. Not for small changes with an obvious fix, pure bug fixes, or investigation tasks that produce no plan.
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
  the decision table distinguishes dev-blocking from go-live-blocking; step 6
  produced concrete findings (a zero-finding review of a v1 plan is a red flag, not
  a pass).
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
- Verified in: virchant_wei_Page, 2026-07-03 — process executed end-to-end (25
  research/verify agents + 3-lens plan review) producing `docs/p2-plan.md` v2;
  execution of that plan itself is the project's P2, pending

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
  bodies' blocked-by lines.
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
