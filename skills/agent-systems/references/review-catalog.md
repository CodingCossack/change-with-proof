# Review Catalogue

Smells are inspection prompts, not automatic deletion orders. Each smell should lead to a preferred response and proof.

## Architecture and scope

| Smell | Preferred response |
|---|---|
| One-use factory/manager/registry/plugin layer | Inline or direct implementation unless a real variant/boundary earns the abstraction. |
| Parallel implementations with unclear ownership | Pick an owner, migrate references, retire the old path, or document/test the real contract requiring both. |
| New validation/parsing/serialization stack beside an existing one | Reuse the canonical stack or state why the boundary requires a new one. |
| Broad refactor mixed into a bugfix | Split or revert unrelated changes unless required for the root cause. |

## Error handling

| Smell | Preferred response |
|---|---|
| Empty `catch`/`except`, broad catch returning defaults | Return/throw explicit error or implement tested observable boundary degradation. |
| Placeholder success after unexpected failure | Fail loudly with context safe for the caller. |
| Fallback to deprecated logic “just in case” | Delete or preserve only if a named contract requires it and proof covers it. |
| User-facing error leaks stack/internal state | Convert to product/action language and move internals to logs/debug surfaces. |

## Types and schemas

| Smell | Preferred response |
|---|---|
| `any`, unchecked cast, broad map/object type | Validate/narrow at boundary; introduce precise domain type. |
| `unknown` used deep inside core logic | Parse at ingress, then carry validated internal representation. |
| Duplicate DTOs for same concept | Establish canonical schema/type owner. |
| Optional fields added to silence errors | Model actual nullability/absence and handle it deliberately. |

## Tests and proof

| Smell | Preferred response |
|---|---|
| Test mocks the subject under test | Move fake to external boundary or use real path. |
| Test asserts only function calls | Assert output, state, side effect, persisted value, rendered text, or artifact. |
| Snapshot/golden updated blindly | Review as contract/product diff. |
| Test name claims more than body proves | Narrow claim or strengthen test. |
| Deleting failing test | Replace with stronger proof if contract intentionally changed. |

## UI/product surfaces

| Smell | Preferred response |
|---|---|
| Visible copy explains implementation | Rewrite around task, state, outcome, next action, recovery. |
| Debug/process/prototype language on committed surface | Move to admin/debug/internal surface or remove. |
| Raw hidden IDs where labels/statuses would do | Show domain identifiers; keep raw IDs for developer/admin contexts. |
| Research/planning notes become product feature | Translate into user value or keep as internal artifact. |

## Long-task/process smells

| Smell | Preferred response |
|---|---|
| Original goal disappears after many steps | Rebuild task ledger before continuing. |
| Rejected approach returns later | Add it to rejected approaches with reason. |
| “Looks done” after scaffolding only | Report usable behaviour separately from unproven structure. |
| Broad file churn without proof | Reduce slice or add proof/checkpoint before continuing. |
