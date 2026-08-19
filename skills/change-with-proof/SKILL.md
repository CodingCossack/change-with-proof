---
name: change-with-proof
description: Use when implementing, debugging, refactoring, testing, reviewing, or completing non-trivial changes to software — bugs, flaky tests, regressions, refactors, migrations, API or schema changes, auth, permissions, secrets, payments, webhooks, persistence, uploads, routing, exports, UI and user-visible surfaces, external integrations, dead-code or legacy removal, and long-running or resumed multi-step work. Do not use for pure explanation or Q&A, greenfield scaffolding with no existing behaviour at stake, prompt writing, dedicated security audits, or visual design.
---

# Change with Proof

Complete or review the requested change without letting compatibility, safety, or completion
claims outrun evidence.

Repository and harness instructions, including `AGENTS.md` when present, remain authoritative.
When a more specialised skill is active for part of the work (a dedicated security audit,
visual design, prompt writing), let it own that part; use this skill for the engineering
control loop around it.

When `anti-machinery` is available, use it alongside this skill: this skill owns contracts and
evidence; `anti-machinery` governs the creation, retention, and retirement of supporting
machinery.

Trivial, low-risk changes: follow repo conventions, report evidence, and skip the rest of
this file.

## 1. Change contract

Before editing, classify each materially affected behaviour or surface:

- **Disposition** — preserve | change | migrate | retire.
- **Strength** — weak signal | intentional behaviour | hard contract. For anything above weak,
  name the source (user request, docs, tests, schema, release, config, code) and the consumer
  (user, API client, persisted data, another module, CI, export consumer).
- **Reversibility** — reversible | costly | one-way. Costly or one-way changes need the
  strongest proof and an explicit rollback statement.

Existing tests and snapshots are important signals, but not automatically sacred. If a test
asserts implementation trivia, stale scaffold, or accidental behaviour, replace it with
stronger proof of the intended contract instead of preserving the accident.

State unresolved uncertainty as one line of named assumptions. Ask before proceeding only when
a disposition materially affects data, security, money, public API, or user-visible semantics
and cannot be resolved by inspection.

Never change business behaviour (pricing, quotas, retention, entitlements) as a silent side
effect of a fix, resilience work, or cleanup. That is a contract change: surface it as a
decision.

## 2. Risk profiles

Read every profile whose trigger matches — the union, not a curated subset. Skip them all when
none match.

| Trigger | Read |
|---|---|
| Observed failure: bug, failing or flaky test, regression, unexpected output | `profiles/causal-debugging.md` |
| Changing, migrating, or retiring a hard contract: public API, schema, persisted data, versioned artifact | `profiles/contract-evolution.md` |
| Identity, permissions, tenancy, secrets, untrusted input, uploads, routing | `profiles/trust-boundaries.md` |
| Persistence, transactions, retries, webhooks, payments, queues, caches, external side effects | `profiles/stateful-integrations.md` |
| Rendering, interaction, product copy, notifications, exports, or other user-facing output | `profiles/user-visible-surfaces.md` |
| Deletion, replacement, consolidation, legacy or fallback removal, dependency retirement | `profiles/replacement-closure.md` |

## 3. Proof portfolio

Prove each invariant at the lowest seam that still contains the real risk. A proof is useful
only if it would fail when the important behaviour broke. When a higher seam demands new
durable apparatus, first name the residual product risk the cheaper seam misses. Apparatus
that exists only to prove the proof mechanism does not cover product risk; simplify or move
the original proof instead. Apparatus disproportionate to the residual product risk likewise
means the seam is wrong, not that the apparatus is needed. Select the smallest set of evidence
that covers every material changed risk; for each item, know the representative regression
that would make it fail. One check may discharge several risks.

| Risk lives in... | Prefer proof such as... |
|---|---|
| Pure calculation, formatting, parsing rule | Unit, fixture, or property-style test with edge cases. |
| Parser/schema/validation boundary | Schema contract test with valid and invalid fixtures. |
| Data transformation or normalization | Fixture tests, property tests where invariants are broad. |
| Internal adapter/wiring/orchestration | Integration test through the real module boundary. |
| External API/service | Boundary fake, recorded fixture, or contract test at the external port; keep internal production path intact. |
| API route/webhook | Request/response contract test, including rejected inputs and status codes. |
| UI route/user flow | Browser smoke or rendered component/route proof when rendering, routing, state, or interaction is the risk. |
| Persistence/migration | Representative fixture, migration, and round-trip proof. |
| Auth/permissions | Allowed/denied matrix across role/action/resource. |
| Export/generated artifact | Golden/approval diff with stable ordering; regenerate twice if nondeterminism is a risk. |
| Dependency architecture | Dependency graph/cycle check plus build/typecheck. |
| Dead-code cleanup | Reachability/dead-code candidate scan plus build/typecheck/route audit as appropriate. |

Test doubles are valid outside the seam being proven. A fake should encode the external
boundary contract, not reimplement production logic or assert the answer you want. Do not mock
the subject whose behaviour you claim to verify, and do not assert only that a call happened
when the behaviour that matters is output, state, persistence, rendered text, a security
decision, or artifact shape.

For bugfixes, keep the counterfactual: the same proof fails on the original bug and passes
after the smallest fix. If automated RED is infeasible, use the strongest deterministic repro
and name the gap.

Prefer commands discovered from the repo (package/task files, CI config, docs, existing tests)
over invented ones. If none exist, say what you ran and why it is only partial proof.

## 4. Execution

Work in vertical slices: implement → prove → clean → continue. Locate the owner of the
behaviour and change it there rather than wrapping symptoms.

For long-running, multi-file, or resumed work, keep one durable state block, updated at slice
boundaries — and treat any inherited summary as claims to re-verify against repo-visible facts
(diff, tests, logs), not as truth:

```text
Goal / stop condition:
Contract dispositions:
Profiles in play:
Done and proven:
In progress:
Proof still needed:
Decisions and rejected approaches:
Gaps / assumptions:
Next smallest step:
```

Populate only the material fields. Put durable state in an existing approved surface (issue,
PR description, task file); do not invent new repo state files, and never leak process notes
into product surfaces.

## 5. Completion gate

Before claiming done:

- Every changed hunk maps to the goal, a contract obligation, a risk treatment, or proof.
  Revert incidental formatting, renames, and drive-by "improvements".
- Every claim has matching-scope evidence: "typecheck passed" does not prove the browser flow;
  "unit test passed" does not prove the route; "no grep hits" does not prove no dynamic
  references.
- Every material risk has evidence or a named gap. Failed or skipped checks are reported as
  failed or skipped.

Final report — omit empty sections; no process narration:

```text
Outcome: <what changed, including intentional contract changes>
Evidence: <check → the claim it supports>
Gaps: <unverified risks; "none" only when true>
Changed: <paths intentionally touched or retired>
```
