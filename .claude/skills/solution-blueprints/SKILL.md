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
