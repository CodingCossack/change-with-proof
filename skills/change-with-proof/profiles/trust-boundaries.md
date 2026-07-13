# Trust Boundaries

## Trigger

Identity, authentication, permissions, tenancy, secrets, untrusted input, uploads or
downloads, or routing/navigation changes.

## Additional obligations

- State the boundary: which inputs are controlled by a user or external system, and which
  contract is being preserved or changed. Expected failures are handled explicitly and
  observably; unknown or unverified degraded behaviour fails loudly rather than producing
  placeholder success.
- Auth and permissions: build a role/action/resource matrix and test allowed **and** denied
  cases. Verify server-side enforcement, not only UI affordances. Fail closed when identity,
  permission, or resource ownership is unclear.
- Tenant isolation: scope multi-tenant reads and writes at the query/storage layer, not only
  via app-level filters. The matrix includes "tenant A cannot read or write tenant B's
  resource by ID."
- Check-then-act atomicity: a permission or availability check must be atomic with the action
  it gates (same transaction or conditional write), not a separate step a race can slip
  through.
- CSRF: state-changing endpoints reachable from a browser session need token, SameSite, or
  origin protection — unless proven bearer-token-only.
- SSRF: server-side fetches of user-supplied URLs validate or allowlist the destination and
  block internal, link-local, and cloud-metadata addresses.
- Rate limiting: login, signup, OTP/reset, expensive, or notification-sending endpoints get
  throttling — or a named out-of-scope gap.
- Uploads and downloads: validate size, type, name/path, content assumptions, storage key,
  and access control. Include malformed, oversized, wrong-type, and traversal-style cases.
  Return safe, actionable errors without leaking internals.
- Routing: inventory the affected entrypoints — direct URL, deep link, redirect, API route,
  not-found, unauthorized, in-app navigation — and prove the risky ones at the request or
  browser level, not only with a component test.
- Secrets: never in logs, exports, artifacts, tests, or screenshots; prefer safe digests/IDs
  in error context.
- Untrusted input: normalize and validate at ingress; test valid, invalid, malformed,
  boundary, and malicious-looking inputs; carry precise internal types after validation.

## Characteristic failure modes

- Object-level access to another tenant's resource by guessable ID.
- Check-then-act race on a permission- or availability-gated mutation.
- Open redirect or SSRF through a user-supplied URL.
- State-changing browser endpoint without CSRF protection; OTP endpoint without throttling.
- Allowed-only test matrix — denial and cross-tenant cases never exercised.
- Secrets or internal identifiers leaking through logs, errors, or exports.

## Minimum evidence

- Allowed/denied matrix including cross-tenant denial where tenancy exists.
- Ingress validation tests including malicious-looking inputs.
- Explicit applicability statements for CSRF, SSRF, and rate limiting — "not applicable
  because …" counts; silence does not.

## Exit criteria

- Fail-closed behaviour demonstrated at the changed boundary.
- Proof matrix covers positive, negative, and cross-tenant paths for the changed contract.
- No secret or internal leakage in any produced output; every applicability statement made.
