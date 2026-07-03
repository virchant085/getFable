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

### Locale switcher 404s on rapid clicks (`/xx/xx` double prefix), active button lags the URL
- Environment: Next.js App Router + next-intl (locale-prefixed routing, client-side switching)
- Surface error: second click during a locale switch navigates to a double-prefixed
  path (`/zh/zh`) → 404; the switcher's active highlight stays on the previous locale
- Real cause: next-intl's `usePathname()`/`useLocale()` strip the locale prefix via
  React **context**, which lags one render behind the URL during a client-side
  transition — mid-switch `usePathname()` returns the still-prefixed path, and
  `router.replace(path, { locale })` prefixes it again
- Observation point: compare next-intl's `usePathname()` against raw
  `next/navigation` `usePathname()` mid-switch (the raw one moves first). Fix: derive
  locale + remainder deterministically from the raw pathname matched against
  `routing.locales`, never from context. Accept the fix by firing several
  **synchronous** clicks (before React re-renders) — a single-click test cannot hit
  the race window
- Provenance: virchant_wei_Page commit `5b52507`

### React 19 dev error "Encountered a script tag while rendering React component"
- Environment: Next.js 15/16 + React 19 + next-themes (≤0.4.6; unmaintained since 2025-03)
- Surface error: `Encountered a script tag while rendering React component. Scripts
  inside React components are never executed when rendering on the client…` — call
  stack points at your own ThemeProvider wrapper / root layout
- Real cause: next-themes injects its no-FOUC theme `<script>` inside the provider,
  and React 19's dev-only check flags ANY client-rendered `<script>`. It is a false
  positive: the script already executed during SSR, and React strips the check from
  production builds — nothing ships broken
- Observation point: it fires on a cold page load with zero interaction (proving your
  feature code is not the trigger). Upstream: shadcn-ui#10104, next-themes#387.
  Leave it tracked (dev-only), or use shadcn's dev-only single-string console.error
  filter; passing a CSP `nonce` prop does NOT silence it — that solves an unrelated
  CSP concern
- Provenance: virchant_wei_Page commit `ad3d9d4` (tracked in docs/hardening.md with upstream links)

### One locale's page looks "compressed" versus the other (CJK/Latin bilingual UI)
- Environment: any bilingual UI mixing CJK and Latin locales (zh/en, ja/en, …)
- Surface error: none — the CJK page simply renders visibly shorter/tighter than the
  Latin page, and suspicion lands on locale-specific CSS that doesn't exist
- Real cause: translation length. CJK copy runs ~⅓–½ the visual length of its English
  equivalent — a headline wrapping to 2 lines in English fits 1 line in CJK, and every
  height computed from text flow collapses with it
- Observation point: measure the same elements' `getBoundingClientRect().height` in
  both locales (screenshots mislead; DOM numbers don't). Fix: reserve line-count
  heights (`min-h` ≈ line-height × expected lines) on the text blocks that drive the
  layout, so locales stay proportionally identical
- Provenance: virchant_wei_Page commit `3c3b3c0`

### CI migrations fail against a plain Postgres container (drizzle-kit + Neon)
- Environment: drizzle-kit (≥0.30 driver auto-detection) + `@neondatabase/serverless`
  in dependencies + any plain-TCP Postgres target (CI service container, local PG)
- Surface error: `Using '@neondatabase/serverless' driver for database querying` +
  `Warning: ... can only connect to remote Neon ... through a websocket` → spinner →
  exit 1. **drizzle-kit swallows the underlying connection error** (stderr is empty,
  no ECONNREFUSED ever prints) — the driver banner line is the only tell
- Real cause: drizzle-kit auto-detects its connection driver from installed packages;
  with only the Neon serverless driver present it picks the WebSocket driver, which
  cannot speak plain TCP. The app's own driver imports are irrelevant — this is the
  CLI's independent detection
- Observation point: the `Using 'X' driver` banner in the migrate output. Fix: add
  `pg` (node-postgres) as a devDependency — detection prefers it, the CLI speaks
  plain TCP, the app runtime (explicit driver imports) is untouched
- Provenance: virchant_wei_Page CI run 28683394908 (first live run of the
  migration-proof job) + fix commit `f0b9029`

### Offline CLI subcommands demand credentials (CLI config routed through a fail-closed env module)
- Environment: any repo with a fail-closed typed env module + a CLI tool whose config
  file is plain code evaluated at load (drizzle-kit, and the pattern generalizes)
- Surface error: a purely offline subcommand (`drizzle-kit generate` — a schema diff
  that touches no database) dies at config load with the env module's
  missing-variable error
- Real cause: the config file read connection strings through the app's fail-closed
  env seam; CLI configs are evaluated eagerly for EVERY subcommand, so the offline
  ones inherit the online ones' requirements. Trap variant: the bug hides if
  verification runs in a shell where placeholder env vars are exported (see the
  acceptance-bar "environment-stated evidence" gate)
- Observation point: run the offline subcommand in a PROVABLY clean shell (print an
  env check first). Fix: CLI config reads `process.env.X ?? ""` leniently — the CLI
  layer sits outside the app boundary; online subcommands still fail closed via the
  tool's own param validation, and the app-runtime seam keeps strict semantics
- Provenance: virchant_wei_Page commit `d18538e` (supervisor-caught during issue #24)

## Related

- If diagnosis cost exceeded half a day, archive it in
  [incident-review](../incident-review/SKILL.md).
