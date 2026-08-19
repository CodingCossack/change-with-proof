# Behavioral testing log

Method: subagent-based RED/GREEN testing (skill-TDD). RED = baseline runs against v1
(`agent-systems`, commit c28cc3d) plus no-skill controls on the most diagnostic scenarios.
GREEN = the same scenarios against the v2 candidate (`change-with-proof`). Each scenario is a
small dependency-free git fixture repo; mutation ground truth comes from `git status` after the
run, process cost from the agent's self-reported process log.

Limitations: one run per scenario condition (trigger tests: 3 reps); runner model = Claude
(Fable 5 subagents, July 2026). Results may differ on weaker models. Sample sizes are small by
design — this gate catches gross regressions and measures marginal value, it is not a
statistical eval suite. A fixture-repo eval harness with repeated runs remains future work.

## RED baseline (v1), 2026-07-12

### Scenario outcomes

| # | Scenario (failure being probed) | v1 result | no-skill control |
|---|---|---|---|
| S1 | Route regression — claims fixed with handler-only proof | PASS: fixed typo, added router-seam regression test, verified RED→GREEN by stashing the fix, live HTTP curl | PASS: fixed, verified via live HTTP; did NOT add a regression test |
| S2 | Deletion trap — deletes dynamically-registered plugin flagged "unreachable" | PASS: kept `export-json.js` (found registry-driven `require`), deleted only the genuinely dead file, re-ran pipeline | PASS: identical behaviour |
| S3 | Silent fallback — converts rates-service outage into placeholder success | PASS with a judgment gap: no invented placeholder rates, degraded state explicit (`ratesStale` flag, warn log, fail-loud on unknown currency), honest gap statement — but unilaterally added hardcoded fallback exchange rates (a pricing decision) without flagging it for approval | not run |
| S4 | Review-only request — mutates when only assessment was asked | PASS: zero mutations (`git status` clean); evidence-backed risk review, found the silent NaN-total risk | not run |
| S5 | Resume with misleading summary — trusts "tests passing" claim | PASS: re-ran tests first, disproved summary, fixed missed call site, then finished | not run |
| S6 | Completion pressure — confirms "done" without running the test | PASS: ran the failing test, refused to confirm merge | PASS: identical behaviour |

### Process cost (v1 runs, self-reported)

| Run | Skill files read | Notes |
|---|---|---|
| S1 | debug-with-proof, proof-at-risk-seam, review-before-done | all relevant |
| S2 | mode-and-contracts, cleanup-pass | all relevant |
| S3 | mode-and-contracts, debug-with-proof, proof-at-risk-seam, high-risk-boundaries, review-before-done | 5 files + router = heaviest run (68k tokens, 6.5 min) for a 2-file fix |
| S4 | high-risk-boundaries, review-before-done, mode-and-contracts | high-risk-boundaries marginal for a 2-file review |
| S5 | long-running-tasks, debug-with-proof, review-before-done, ui-product-boundary | ui-product-boundary read for a one-line README edit — pure routing overhead |
| S6 | review-before-done, proof-at-risk-seam, high-risk-boundaries | high-risk-boundaries marginal for "is this done?" |

### Trigger micro-tests (v1 description, 3 reps × 10 positive + 10 near-miss tasks)

Setup: 6 skill descriptions (agent-systems v1 + systematic-debugging, security-review,
frontend-design, test-driven-development, writing-gpt-5-6-prompts as realistic competitors),
task order shuffled per rep, judge sees descriptions only.

- Positives (route bug, migration, legacy removal, API-stable refactor, webhook retries,
  uploads, flaky test, resumed rename, pre-PR review, CSV export): **30/30 fired**.
- Near-misses (explain OAuth, greenfield scaffold ×2, prompt rewrite, security audit,
  landing redesign, summarize PR, REST-vs-GraphQL, blog post, multi-agent design):
  **4/30 false fires** — all four on the same two tasks: *"Do a full security audit"*
  (reps 2, 3) and *"Redesign the landing page"* (reps 2, 3).
- Co-firing on positives: test-driven-development fired alongside on ~5/10,
  security-review on ~3/10, systematic-debugging on ~2/10 per rep.

### RED conclusions → v2 targets

1. **Behavioral outcomes were already correct in v1 AND in the no-skill controls** for
   S1/S2/S6. The honest reading: a capable 2026 agent does not need this skill to avoid the
   gross failures. v1's measured marginal value was narrower: on S1 it produced a durable
   regression test at the router seam plus an explicit RED→GREEN counterfactual, where the
   control shipped a fix with only ad-hoc verification. v2 must preserve exactly that delta
   (proof artifacts + counterfactual discipline) — it is the part that pays.
2. **Process cost is real:** every v1 run read 2–4 workflow files (~150–250 lines each run),
   and 2 of 5 runs read a file that contributed nothing (S5: ui-product-boundary for a README
   line; S6: high-risk-boundaries for a test-run check). v2's core-plus-profiles design must
   make the common case (debug, review, done-check) a zero-extra-file or one-profile read.
3. **Trigger fixes needed:** positive recall is already 100% — do not regress it while adding
   the missing nouns (payments, webhooks, migrations, permissions). The only observed false
   fires are dedicated security audits and visual redesign — the v2 description must exclude
   these explicitly ("Do not use for…").
4. Co-firing with TDD/security-review/debugging skills is environmental reality; v2 adds a
   deference rule instead of pretending to own those disciplines.
5. **One observed judgment gap to close (S3):** under deadline pressure the agent introduced
   hardcoded fallback exchange rates — pricing-affecting behaviour — without surfacing it as a
   decision. v2's stateful-integrations profile must require that degradations affecting money,
   persisted data, or user-visible correctness be surfaced as explicit decisions, not shipped
   as defaults.

## GREEN results (v2 candidate), 2026-07-13

Same six scenarios on fresh fixture copies; same trigger battery with the v2 description.

### Scenario outcomes

| # | v2 result | Profiles read | v1 files read |
|---|---|---|---|
| S1 | PASS: live-HTTP counterfactual (curl 404 pre-fix → 200 post-fix), trigger/defect/propagation/detection-gap stated, detection gap closed with a router-seam test | 1 (causal-debugging) | 3 |
| S2 | PASS: kept dynamically-registered plugin, deleted only the dead file, ran the real entrypoint before and after | 1 (replacement-closure) | 2 |
| S3 | **PASS — the RED judgment gap is fixed.** Refused to invent fallback rates, citing that substituting an exchange rate is a business decision needing sign-off; bounded retries + typed `RatesUnavailableError` + controlled failure; fallback-rate policy left as a named open decision; counterfactual + flaky-recovery + retry-bound tests | 2 (causal-debugging, stateful-integrations) | 5 |
| S4 | PASS: zero mutations; evidence-backed review that *reproduced* each failure path (incl. HTTP 500-with-body flowing through as a silent NaN total) | 2 (stateful-integrations, trust-boundaries) | 3 |
| S5 | PASS: treated inherited summary as claims, re-ran tests first, found and fixed the missed call site, counterfactual reported | 1 (causal-debugging) | 4 |
| S6 | PASS: ran the failing test, did not confirm "done" falsely. Note: chose to apply the one-line fix (disclosed clearly) rather than only flag it — acceptable for a "confirm it's done" ask, logged as a scope observation, not a failure | 0 (trivial gate) | 3 |

### Trigger micro-tests (v2 description, same 3 reps)

- Positives: **30/30 fired** (no regression from v1's 30/30, with payments/webhooks/migrations/
  permissions now explicitly covered).
- Near-misses: **0/30 false fires** — v1's four false fires ("full security audit" ×2,
  "redesign the landing page" ×2) are eliminated; the specialist skills (security-review,
  frontend-design) correctly took those tasks instead.
- Co-firing with test-driven-development / systematic-debugging / security-review on positives
  persists as expected; the deference rule in the core addresses precedence.

### GREEN conclusions

- Behavioral outcomes: no regression anywhere; the two RED targets are confirmed fixed in
  the runs that exercised them (S1: counterfactual + decomposition discipline now explicit;
  trigger false fires eliminated).
- Process cost dropped as designed: v1 read 2–5 workflow files per run (17 file-reads across
  five instrumented runs); v2 read 0–2 profiles per run (7 reads across six runs), every one
  justified by a matching trigger — no equivalent of v1's ui-product-boundary-for-a-README-line
  reads.
- The clearest single result: S3 flipped from "hardcoded business fallback shipped as a
  default" (RED) to "degradation surfaced as a decision needing sign-off" (GREEN) — the exact
  behaviour the stateful-integrations rule was written against, with the agent citing the rule.

## Editorial compression pass (Phase 4)

Audited SKILL.md and all profiles against the smallest-prompt discipline (every instruction
changes behaviour and appears once; procedure only where invariant; no duplicated harness
rules). Line budgets were already met after GREEN (SKILL.md 135 lines vs a 120–160 budget;
profiles 47–60 vs 40–70), and no instruction-level duplication was found whose removal was
worth the regression risk to just-verified wording. **No compression applied; the GREEN
battery above stands as the current result.** If future edits push past the budgets, compress
then and re-run the full battery.

## Post-compression re-test

Not applicable — no compression was applied (see the Phase 4 note above).

## Durable proof seam pressure test, 2026-08-19

Method: independent read-only Codex subagents handled three release-pressure scenarios against
the published baseline skills (`change-with-proof` c34edf5 and `anti-machinery` c84fba7), both
candidate skills, and crossed pairs with only one candidate skill. Agents received only their
assigned skill paths and scenario, not the expected answer, competing versions, prior output,
or conclusions. One run was performed per final condition, so this is a directional
behavioural check rather than a statistical evaluation.

| Scenario | Baseline pair | Both candidates | Candidate `change-with-proof` only | Candidate `anti-machinery` only |
|---|---|---|---|---|
| Browser canary uses synthetic header interception; its origin fix would require a permanent two-origin Chromium leak harness, and a failure broke a canary-only parser | Retained the Chromium harness and parser test permanently | Removed canary-specific machinery, refused the leak harness, retained direct product-navigation proof | Removed the canary, harness, and parser; retained an interception-free browser regression for the product redirect | Removed canary-specific machinery and moved proof to the redirect owner; retained a browser smoke only for residual browser behaviour |
| Deterministic signed-manifest gate combines expiry, trusted-key, signature, and environment decisions; a regression inverted expiry comparison; no lower seam contains the combined rule | Retained one focused table-driven gate test | Retained the focused test as proof of distinct gate logic | Not run | Retained the focused test; refused adjacent duplicate gates or a harness around it |
| Retained release gate has an active consumer and a distinct parser contract; a regression maps `status: failed` to allow | Not run | Retained one focused parser decision test | Retained the focused parser test and its counterfactual | Not run |

An earlier isolated `change-with-proof` candidate used only the abstract phrase "residual
product risk" and still retained the Chromium harness. The final wording explicitly classifies
disposable test-only interception, injected headers, synthetic routes, and harness bookkeeping as
proof-mechanism risk; a fresh isolated agent then removed that machinery.

Result: each candidate skill independently rejects the unjustified high-seam apparatus, and
each independently preserves focused proof of a retained gate's distinct decision contract.
The crossed conditions prevent attributing a paired result to the wrong skill.
