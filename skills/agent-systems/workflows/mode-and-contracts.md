# Mode and Contract Workflow

Use this before non-trivial edits when deciding what can be deleted, what must be preserved, and what proof standard applies.

## 1. Classify the surface

| Mode | Meaning | Default posture | Proof posture |
|---|---|---|---|
| Dead scaffold | Template/demo/abandoned code with no current owner, no meaningful inbound use, or behaviour that conflicts with the goal | Delete or replace. Do not preserve compatibility for it. | Show references are gone/updated and checks still pass. |
| Active prototype | No external contract yet, but the current user goal matters | Simplify aggressively. Preserve user-stated invariants. Prefer direct implementation. | Prove the core path works through the smallest real seam. |
| Committed product surface | Intended route, UI, export, workflow, or API even if still pre-production | Preserve user-visible semantics unless the task changes them. | Prove the affected product behaviour. |
| Explicit contract | Externally relied-on invariant: persisted data, released API/route/export/schema, current docs, intentional accepted test/snapshot, compatibility promise, or user-stated requirement | Preserve or intentionally migrate/change. | Contract proof: migration, API/route, golden, fixture, or compatibility test. |

A repo can contain all four modes at once. Classify the specific surface being changed, not the whole repo by vibe.

## 2. Establish contract provenance

For each possible contract, record:

- **Source:** where it is asserted: user request, docs, tests, migrations, routes, schema, release notes, production config, external integration, current code.
- **Freshness:** current, stale, scaffold-derived, contradicted, unknown.
- **Consumer:** who or what relies on it: user, API client, persisted data, another module, CI, export consumer.
- **Strength:** hard contract, soft signal, accidental residue.
- **Proof needed:** what would show preservation or intentional change.

Existing tests and snapshots are important signals, but not automatically sacred. If a test asserts implementation trivia, stale scaffold, or accidental behaviour, replace it with stronger proof of the intended contract instead of preserving the accident.

## 3. Positive operating rules

- Preserve hard contracts unless the task explicitly changes them.
- Treat soft signals as evidence to inspect, not as automatic compatibility burdens.
- Delete accidental residue when it blocks the clean target design.
- When changing a contract, name the old contract, the new contract, the migration/compatibility story, and the proof.
- In prototypes, freedom to refactor does not erase user-stated invariants.

## 4. Output for non-trivial work

```text
Mode:
Contracts discovered:
Soft signals inspected:
Accidental residue to remove:
Contract changes, if any:
Proof needed:
```

Block only when contract provenance materially affects data, security, public API, user-visible semantics, or proof and cannot be resolved by inspection.
