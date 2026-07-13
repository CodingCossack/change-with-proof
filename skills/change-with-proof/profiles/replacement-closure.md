# Replacement Closure

## Trigger

Deletion, dead-code removal, duplicate or type consolidation, legacy or fallback removal,
refactor-driven retirement, or dependency removal.

## Additional obligations

- Candidates, not authority: dead-code tools and grep produce candidates. Before deleting,
  check the dynamic reference points grep cannot see — string-keyed registries and manifests,
  plugin loaders, route conventions, dependency-injection containers, reflection, codegen,
  decorator registration, framework auto-discovery, string-referenced tests, and external
  consumers.
- Replacement closure: when replacing or deleting a path, account for inbound imports and
  dynamic references; public exports and entrypoints; routes, navigation, manifests, plugin
  registries, codegen configs, DI, framework conventions; tests, fixtures, snapshots, mocks,
  and generated artifacts; docs, comments, product strings, examples, scripts, and config;
  types, schemas, validators, API clients, and serialized shapes.
- No parallel implementations after a replacement unless a named contract requires both — and
  proof covers both.
- Type and schema consolidation: one canonical owner per domain concept; validate unknown data
  at the boundary, then carry precise internal types; keep runtime schema and static type
  derived from or checked against one source; use discriminated unions for variants; make
  nullability meaningful; no casts without prior narrowing or validation.
- Abstraction: prefer direct code over one-use factories, managers, registries, or
  configuration layers. Introduce abstraction only for a named invariant, a dependency
  boundary, or multiple real callers.
- Comments: keep those documenting non-obvious invariants, algorithms, security assumptions,
  external constraints, or compatibility contracts. Remove agent-activity notes, migration
  history, obvious-code narration, and ownerless TODOs.

## Characteristic failure modes

- Deleting a handler referenced only through a registry, manifest, or naming convention —
  grep finds nothing, production breaks.
- Retired path still reachable from a route, manifest, or generated artifact.
- Consolidation that leaves both copies alive.
- Snapshot or fixture still asserting behaviour that was deliberately removed.
- A comment documenting a security or compatibility invariant deleted as noise.

## Minimum evidence

- Reachability/dead-code scan **plus** an explicit dynamic-registration check **plus**
  build/typecheck, and a route/manifest audit where relevant.
- Run the real entrypoint when that is cheap.

## Exit criteria

- No static or dynamic reference to the retired path remains reachable.
- The closure checklist is accounted for — "grep found nothing" is never the sole
  justification.
