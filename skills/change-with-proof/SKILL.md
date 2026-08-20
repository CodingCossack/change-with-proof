---
name: change-with-proof
description: Use when changing software whose existing behaviour matters — fixing bugs or regressions, refactoring, migrating schemas or APIs, changing auth, payments, webhooks, persistence, or user-visible behaviour, removing code, resuming inherited work — and when reviewing such changes or judging whether they are done. Every claim of fixed, compatible, unused, or done must carry evidence whose scope matches the claim. Do not use for pure explanation or Q&A, greenfield scaffolding with no existing behaviour at stake, prompt writing, dedicated security audits, or visual design and restyling work, however large.
---

# Change with Proof

Complete or review the change without letting correctness, compatibility, or completion
claims outrun evidence. For trivial edits with no behaviour at stake, follow repository
conventions and simply report what you ran.

## Decide the contract before editing

- For each behaviour the change touches, decide deliberately: preserve, change, or retire.
  For anything that must survive, know its consumer — user, API client, persisted data,
  another module, CI, export consumer.
- Accidental behaviour is not a contract. A typo, a bug's visible side effect, or an
  undocumented shape earns no right to survive: fix it, and do not add a compatibility
  alias or shim for it on speculation that an unknown consumer adapted to it — "someone
  may depend on it" names no consumer. If a real consumer of the accident is identified,
  keeping or transitioning it becomes an explicit decision to surface, never a silent
  default.
- Never alter business behaviour — pricing, quotas, retention, entitlements, or any default
  that changes what users get or pay — as a silent side effect of a fix, fallback,
  resilience work, or cleanup. A degradation that substitutes data or skips an effect is a
  contract change: surface it as a decision needing sign-off, make the degraded state
  observable, and never let it look like healthy output.
- Existing tests and snapshots are signals, not authority: replace a test that asserts
  accidental behaviour or implementation trivia with proof of the intended contract, and
  never regenerate a golden or snapshot to make checks green without reviewing the diff as
  an intentional contract change.
- On resumed or inherited work, treat prior summaries — "tests pass", "X is unused",
  "done" — as claims to re-verify against the repository (diff, tests, logs) before
  building on them.

## Prove at the seam that carries the risk

- Prove each changed risk at the lowest seam that still contains it, with evidence that
  would fail if the behaviour broke. Match claim scope to evidence scope: a typecheck does
  not prove a browser flow, a unit test through a mocked helper does not prove routing or
  persistence, and "no grep hits" does not prove nothing references it dynamically or
  externally.
- For bugfixes, keep the counterfactual: the same repro or test fails on the original bug
  and passes after the smallest fix — and leave that test in place at the seam that missed
  the bug. When automated RED is infeasible, use the strongest deterministic repro and name
  the gap.
- Never mock the subject whose behaviour you claim to verify, and never assert only that a
  call happened when the risk is output, state, persistence, rendered text, or a security
  decision.
- Keep proof apparatus proportional to the residual product risk. Test-only interception,
  injected headers, synthetic routes, and harness bookkeeping are proof-mechanism risk, not
  product risk: when they fail, simplify or move the proof instead of building permanent
  apparatus around it. A retained gate's own parsing or decision contract is product
  behaviour and may deserve one focused test.
- Prefer commands the repository already defines (package scripts, CI, docs) over invented
  ones.

## Gate the claim of done

- Every changed hunk maps to the goal, a contract decision, or proof; revert incidental
  reformatting and drive-by improvements.
- Every material risk has matching-scope evidence or a named gap; failed or skipped checks
  are reported as failed or skipped, never folded into "done".
- Report: the outcome including intentional contract changes; each claim with the evidence
  backing it; gaps ("none" only when true); files changed.

When `anti-machinery` is installed, it governs what supporting apparatus may remain after
the task closes; this skill governs what must change and how it is proven.
