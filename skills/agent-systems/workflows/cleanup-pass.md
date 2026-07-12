# Cleanup and Retirement Workflow

Use for refactors, dead-code removal, duplicate consolidation, weak typing, circular dependencies, fallback/legacy removal, or agent-generated slop.

## Staged cleanup protocol

1. **Inventory:** identify candidates and the owner path: code, types, config, routes, tests, docs, generated artifacts.
2. **Classify:** contract, soft signal, accidental residue, or unknown.
3. **Plan:** choose deletion, consolidation, direct replacement, or leave-with-reason.
4. **Change:** make the smallest coherent slice that closes the graph.
5. **Verify:** run checks appropriate to the risk: build/typecheck/tests/dead-code/dependency/route/golden checks.
6. **Report:** state what was retired or consolidated and what proved it safe.

## Replacement closure

When replacing or deleting a path, check:

- Inbound imports/references and dynamic references.
- Public exports and package/module entrypoints.
- Routes, navigation, manifests, plugin registries, codegen configs, reflection, dependency injection, framework conventions.
- Tests, fixtures, snapshots, mocks, and generated artifacts.
- Docs, comments, product strings, examples, scripts, and config.
- Types, schemas, validators, API clients, and serialized shapes.

Do not preserve parallel implementations unless an explicit contract requires both and proof covers both.

## Type and schema consolidation

- Establish one canonical owner for each domain concept.
- Validate unknown/external data at boundaries, then represent valid internal state with precise types.
- Keep runtime schema and static type generated from, inferred from, or checked against one source.
- Use discriminated unions or equivalent for variants.
- Make nullability and optional fields meaningful; do not add optionality only to silence errors.
- Avoid casts unless preceded by narrowing or boundary validation.

## Dead code and dependency candidates

Dead-code tools and grep produce candidates, not deletion authority. Review dynamic framework conventions, plugin systems, route discovery, generated imports, reflection, public APIs, and external consumers before deleting.

## Abstraction and duplication

- Consolidate duplicate code/types when it reduces complexity or establishes a real source of truth.
- Prefer direct code over one-use factories, managers, registries, plugin systems, or configuration layers.
- Introduce abstraction only when it protects a named invariant, dependency boundary, or multiple real callers.

## Comments and documentation

Keep comments that explain non-obvious invariants, algorithms, security assumptions, external constraints, or compatibility contracts. Remove comments about agent activity, temporary migration history, obvious code, or stale TODOs with no owner/action.
