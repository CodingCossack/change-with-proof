# Changelog

## 3.0.0 — 2026-08-19

Breaking rewrite: the skill is a single ~620-word `SKILL.md`. Total payload drops ~84%
(from ~3,450 words across SKILL.md plus six conditional profiles to one file).

### Changed

- The core is reduced to the rules with direct behavioural evidence: contract disposition
  with an explicit "accidental behaviour is not a contract" negation; no silent business-
  behaviour changes (degradation is a surfaced decision); inherited summaries re-verified;
  proof at the risk seam with the bugfix counterfactual; proof-apparatus proportionality;
  claim-scope/evidence-scope matching at completion; the compact final report.
- The activation description leads with "changing software whose existing behaviour
  matters", keeps the measured 30/30 positive recall, and excludes "visual design and
  restyling work, however large" — the one false fire observed in the v3 trigger battery
  under both the v2 and draft v3 descriptions (3/3 reps each; 0/3 after the exclusion).
- Rename the public repository from `agent-systems` to `change-with-proof` and update active
  installation paths and discovery copy. GitHub redirects the previous repository URL.
- Document the optional `anti-machinery` companion skill and its responsibility boundary.
- Enable implicit invocation after the v2 trigger battery achieved 30/30 intended triggers
  and 0/30 near-miss triggers.

### Added

- "Accidental behaviour is not a contract": in the v3 battery a draft-skill agent shipped a
  compatibility alias for a typo route on "someone may have adapted to it" reasoning; this
  rule removed the behaviour in re-runs (see docs/testing.md, 2026-08-19 v3 battery).

### Removed

- `profiles/` (causal-debugging, contract-evolution, trust-boundaries,
  stateful-integrations, user-visible-surfaces, replacement-closure — ~2,330 words of
  conditional payload). The v3 baseline on gpt-5.6-sol showed no-skill controls already
  performing the checklist behaviours these encoded; the two profile rules with measured
  deltas (the root-cause counterfactual gate and "degradation is a decision") moved into
  the core. See docs/design-rationale.md, "Why the profiles were deleted".
- The risk-profile trigger table, the proof-seam taxonomy table, the vertical-slice
  execution section, and the durable state block. The state block's operative rule
  (re-verify inherited summaries) is one line in the core; the rest duplicated current
  model competence or harness behaviour.

## 2.0.0 — 2026-07-13

Breaking rewrite. The skill `agent-systems` is renamed **`change-with-proof`**; the payload
moved from `skills/agent-systems/` to `skills/change-with-proof/`.

### Changed

- One core control loop in `SKILL.md` (change contract → risk profiles → proof portfolio →
  execution → completion gate) replaces the eight-workflow keyword router. A single
  union-of-matching-profiles rule replaces the "common combinations" lists, whose examples
  contradicted the trigger table.
- The four-mode surface taxonomy (dead scaffold / active prototype / committed product
  surface / explicit contract) is replaced by three orthogonal fields: disposition, strength
  with provenance, reversibility.
- Single-proof-seam guidance becomes a proof portfolio: the smallest evidence set covering
  every material changed risk, each item named with the regression that would fail it. The
  v1 proof-seam taxonomy table is preserved.
- Six output templates across five files collapse into one state block and one final report.
- The frontmatter description now covers what the skill actually routes (adds payments,
  webhooks, migrations, permissions) and states negative scope ("Do not use for …").
- `agents/openai.yaml` disables implicit invocation pending trigger evidence.

### Added

- `profiles/causal-debugging.md` — root-cause gate: a discriminating experiment or
  fail-before/pass-after counterfactual is required *before* claiming a confirmed cause
  (v1 allowed causal claims from inspection alone).
- `profiles/contract-evolution.md` — consumer enumeration, transition mechanisms,
  representative-data migration proof, rollback statements.
- `profiles/trust-boundaries.md` — adds tenant isolation, CSRF, SSRF, check-then-act
  atomicity (TOCTOU), and rate limiting to the v1 auth/uploads/routing/secrets/input rules.
- `profiles/stateful-integrations.md` — adds idempotency (deliver twice → one effect),
  partial-failure compensation, cache invalidation, delivery semantics, and
  degradation-is-a-decision (observed RED failure: hardcoded business fallback shipped
  silently under deadline pressure).
- `profiles/user-visible-surfaces.md` — adds required populated/loading/empty/error states
  and locale/missing-translation behaviour to the v1 audience/leak rules.
- `profiles/replacement-closure.md` — dynamic-registration check promoted above the closure
  checklist.
- `docs/testing.md` — subagent-based RED/GREEN behavioral test log and trigger micro-tests.
- `docs/design-rationale.md`, `CHANGELOG.md`.

### Removed

- `scripts/agent_hygiene_scan.sh` — the advisory scanner's patterns flagged every
  `catch`/`except`/`rescue`, every `return true/false`, and the bare word `any` (including
  Python's builtin `any()`); net-negative noise.
- `references/positive-patterns.md`, `references/review-catalog.md`,
  `references/enforcement-map.md`, `references/tooling.md` — the same doctrine restated three
  to four times, plus a generic tool catalogue. Non-generic failure modes were folded into the
  relevant profiles; see `docs/design-rationale.md`.

### Infrastructure

- `scripts/validate.sh` rewritten as a thin orchestrator over `scripts/check_skill.py`
  (stdlib Python): frontmatter parsed by delimiter scan instead of hardcoded line numbers,
  name must match the directory, description rules enforced, relative references resolved,
  profile section contract checked. The ripgrep dependency is gone.
- CI `actions/checkout` pinned to a full commit SHA, consistent with SECURITY.md.

## 1.0.0 — 2026-07-12

Initial publication as `agent-systems`.
