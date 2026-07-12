# Tooling Reference

This is a catalogue of tool categories, not a command list. Prefer tools already adopted by the repo. If useful tooling is absent, recommend it separately rather than inventing commands or adding dependencies inside unrelated work.

## Command discovery sources

- Lockfiles and package-manager files.
- Task runners: Makefile, justfile, package scripts, tox/nox/poe, Gradle/Maven, cargo, CI workflows, repo scripts.
- Existing tests near affected files.
- README/developer docs.
- CI required checks.

## JavaScript / TypeScript candidates

- TypeScript strict mode and `tsc --noEmit`-style typechecks.
- Typed `typescript-eslint` rules.
- `@typescript-eslint/no-explicit-any` or changed-file equivalents.
- Knip for unused files, exports, and dependencies.
- dependency-cruiser or ESLint import rules for boundaries/cycles.
- Madge for dependency graph visualization/secondary cycle review.
- OpenAPI/GraphQL/codegen diff tools where adopted.

## Python candidates

- Ruff for linting and unused import/static hygiene.
- Pyright or mypy for type checking, depending on repo convention.
- Vulture for dead-code candidates, with whitelists and review.
- coverage.py for executed-path and branch evidence.
- import-linter/pydeps-style tools where dependency boundaries matter.

## Cross-language candidates

- ripgrep/grep for cheap targeted scans.
- Semgrep for security/correctness policies.
- ast-grep for syntax-aware search, linting, and codemods.
- Tree-sitter for custom structural analysis.
- Browser tools for user-flow smoke checks and visible text assertions.
- Golden/approval diff tools for exports, schemas, generated content, and snapshots.

## Adoption rules

- Tool output is evidence, not truth. Review false positives and dynamic conventions.
- Prefer changed-surface enforcement before whole-repo enforcement in messy prototypes.
- Do not install tools just to satisfy this skill unless the task is explicitly to create enforcement.
- When suggesting new tooling, state the invariant it would enforce and the likely false positives.
