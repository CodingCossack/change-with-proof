# Contract Evolution

## Trigger

The change contract lands on **change**, **migrate**, or **retire** for a hard contract —
public API, persisted schema or data, released route, versioned export, external integration
shape — or reversibility is **costly** or **one-way**.

## Additional obligations

- Name the old contract, the new contract, and every known consumer (users, API clients,
  persisted rows, other services, docs, CI, export consumers) — and how each one learns of or
  survives the change.
- Choose and state the transition mechanism before deleting the old shape: expand-migrate-
  contract (additive first, remove later), versioned endpoint or schema, feature flag, or a
  dual-read/dual-write window.
- Classify the change additive or breaking. Breaking changes need a version signal — or
  explicit evidence that no external consumer exists.
- For persisted data, prove migration on representative fixtures that include existing
  persisted shapes and edge cases. Success on an empty database is not migration proof.
  Round-trip old→new, and new→old when rollback is claimed. Name data-loss, rollback,
  backfill, and compatibility assumptions.
- Keep both old and new fixtures for the duration of the transition window.
- One-way steps (dropped columns, destructive backfills, published artifacts) get the
  strongest available proof and an explicit rollback or no-rollback statement before they run.
- Treat golden/snapshot updates as contract reviews: confirm the diff is the intended
  product/API/artifact change, never a mechanical refresh to make checks green.

## Characteristic failure modes

- Old shape deleted in the same change while consumers still exist.
- "Backwards compatible" claimed without a round-trip or contract test.
- Empty-database migration success treated as proof for real data.
- Breaking change shipped with no version signal and no consumer evidence.
- Snapshot/golden regenerated to green without reviewing what changed.

## Minimum evidence

- Migration/round-trip proof on representative data.
- Old and new fixtures retained.
- An explicit consumer list and a rollback statement for costly/one-way steps.

## Exit criteria

- Old and new contracts both named; transition mechanism proven, not declared.
- Every known consumer has a working or evidenced path through the change.
- Goldens/snapshots reviewed as intentional contract changes.
