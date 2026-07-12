# High-Risk Boundary Workflow

Use when touching auth, permissions, persistence, migrations, uploads, downloads, exports, manifests, routing, user-controlled input, secrets, payments, external APIs, webhooks, or generated artifacts.

## Boundary protocol

For the affected boundary, identify:

```text
Boundary:
Inputs controlled by user/external system:
Contract to preserve/change:
Expected failure modes:
Explicit failure/degraded behaviour:
Proof matrix:
```

Expected failures should be handled explicitly and observably. Unknown or unverified degraded behaviour should fail loudly rather than silently producing placeholder success.

## Mini-protocols

### Auth and permissions

- Build a role/action/resource matrix.
- Test allowed and denied cases.
- Verify both UI affordances and server/API enforcement when applicable.
- Default to fail closed when identity, permission, or resource ownership is unclear.

### Persistence and migrations

- Use representative fixtures, including existing persisted shapes and edge cases.
- Prove migration/round-trip behaviour.
- Name data-loss, rollback, backfill, and compatibility assumptions.
- Do not treat empty-state success as migration proof.

### Uploads and downloads

- Validate size, type, name/path, content assumptions, storage key, and access control.
- Include malformed, oversized, wrong-type, and traversal-style cases where relevant.
- Return safe, actionable errors without leaking internals.

### Routing and navigation

- Inventory affected entrypoints: direct URL, deep link, redirect, API route, not-found, unauthorized, and navigation path.
- Verify request/response or browser smoke for the routes that carry risk.
- Do not rely only on a component test when routing or server state is the risk.

### Exports, manifests, and generated artifacts

- Define schema/shape, ordering, filenames, metadata, and sensitive-data boundaries.
- Normalize timestamps, randomness, locale, filesystem order, and archive metadata.
- Use golden/diff proof; regenerate twice when nondeterminism is plausible.

### External APIs and webhooks

- Use contract fixtures or boundary fakes at the external port.
- Verify signature/auth validation, idempotency, retries, timeouts, duplicate delivery, and malformed payloads where relevant.
- Keep internal production path under test; fake only the external service.

### Secrets and sensitive data

- Do not log secrets or sensitive payloads.
- Prefer safe digests/IDs in error context.
- Check generated artifacts, exports, logs, screenshots, and tests for accidental leakage.

### User-controlled input

- Normalize and validate at ingress.
- Test valid, invalid, malformed, boundary, and malicious-looking inputs for the affected parser/handler.
- Preserve precise internal types after validation.

## Stop condition

Do not claim boundary safety unless the proof matrix covers both positive and negative paths for the changed contract. If proof is incomplete, report the exact gap.
