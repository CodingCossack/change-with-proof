# Proof at the Risk Seam

Use whenever choosing, writing, or judging verification.

## Core principle

Prove the invariant at the lowest seam that still contains the real risk. A proof is useful when it would fail if the important behaviour broke.

## Proof seam taxonomy

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

## Test doubles

- Fakes, mocks, stubs, and monkeypatches are valid when they sit outside the seam being proven.
- A fake should encode an external boundary contract, not reimplement production logic or assert the answer you want.
- Do not mock the subject whose behaviour you claim to verify.
- Avoid assertions that only prove a call happened when the important behaviour is output, state, persistence, rendered text, security decision, or artifact shape.

## Regression protocol

For bugfixes, prefer:

```text
RED: <test/repro> fails on the original bug.
GREEN: <same test/repro> passes after the smallest fix.
SCOPE: <additional checks> cover affected contracts.
```

If automated RED is not feasible, use the strongest deterministic repro available and explain the proof gap.

## Golden and approval updates

- Treat a golden/snapshot update as a contract review, not a mechanical refresh.
- Confirm the diff reflects the intended product/API/artifact change.
- Stabilize ordering, timestamps, randomness, locales, and archive metadata where relevant.
- Keep old and new fixtures when testing migrations or compatibility.

## Browser/use proof

Use browser proof when the risk is visible rendering, navigation, state transitions, accessibility of an action, auth/routing, or integration with backend data. For isolated pure formatting or copy transformations, a lower seam may be enough.

## Proof gaps

A proof gap is acceptable only when named. Say exactly what remains unverified and why the chosen evidence is still the strongest available.
