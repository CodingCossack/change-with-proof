# Stateful Integrations

## Trigger

Persistence or transactions, queues and background jobs, caches, retries, webhooks, payments,
external APIs, or any multi-step state that crosses a process or service boundary.

## Additional obligations

- External ports: use contract fixtures or boundary fakes at the external port and keep the
  internal production path under real test. Verify signature/auth validation, timeouts,
  retries, duplicate delivery, and malformed payloads where relevant.
- Idempotency: any mutation reachable from a retry or redelivery (webhooks, queue consumers,
  payment confirmations) is proven safe to receive twice — deliver twice, assert one effect.
- Partial failure: multi-step effects (DB write + external call + enqueue) get a stated
  compensating action, reconciliation path, or a **named** acceptable inconsistency — never an
  unstated one.
- Delivery semantics: name at-least-once vs at-most-once, ordering assumptions, and
  dead-letter handling for queue/job consumers.
- Caches: name what invalidates each cache on write, and prove stale reads cannot outlive the
  acceptable window.
- Degradation is a decision: a fallback that alters money, persisted data, or user-visible
  correctness (default rates or prices, placeholder data, skipped writes) is a contract
  change — surface it for approval instead of shipping it as a default, and make degraded
  state observable (flag, log, metric), never indistinguishable from healthy output.
- Persistence: prove against representative fixtures including existing persisted shapes;
  round-trip where shape changes. Schema/data migration rules live in
  `contract-evolution.md`.

## Characteristic failure modes

- Double charge or double send on webhook/queue redelivery.
- Row written with no corresponding external effect (or the reverse) and no reconciliation.
- Stale cache served after the write that should have invalidated it.
- Hardcoded business fallback (rates, prices, limits) silently shipped under deadline
  pressure.
- Retry wrapped around a non-idempotent call.
- Empty-state success treated as persistence proof.

## Minimum evidence

- Duplicate-delivery test (two deliveries → one effect) whenever retries or webhooks are
  touched.
- Partial-failure or compensation proof for multi-step effects.
- Cache-invalidation proof when caching is touched.
- Boundary-contract fixtures including malformed payloads.

## Exit criteria

- State provably consistent — or a named, accepted inconsistency — across retry, duplicate
  delivery, and partial failure.
- Every degraded mode is observable and was approved, not defaulted.
