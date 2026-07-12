# Enforcement Map

Instructions shape behaviour. Tests verify semantics. Static checks enforce structure. CI/hooks make important checks repeatable.

Do not run or invent commands from this file. Discover the repo's actual commands first.

| Invariant | Mechanical candidates | False positives / cautions | Adoption threshold |
|---|---|---|---|
| Commands are discovered, not invented | CI required checks, repo `verify` script, task runner, command allowlist | A repo may not have a single verify command yet | Introduce only as a repo decision, not inside an unrelated fix. |
| No proofless completion | PR template/checklist, CI status, review agent, required checks | Cannot fully enforce semantic honesty | Always useful. |
| No silent fallback | Lint for empty catches, Semgrep/ast-grep for catch-return-default patterns, error-path tests | Expected boundary handling can look similar | Use as candidate scan plus tests. |
| Product surfaces avoid process leakage | Rendered route/export/email/PDF scans, browser assertions, snapshot/golden review | Domain may legitimately use words like “agent”, “debug”, “analysis” | Scope to user-facing paths and audience. |
| Auth/permissions fail closed | Allowed/denied matrix tests, route/API integration tests | UI hiding is not server enforcement | Required for permission changes. |
| Persistence/migrations preserve data | Migration fixtures, round-trip tests, representative DB snapshots | Empty DB tests miss real data contracts | Required for schema/data changes. |
| Upload/input validation is real | Boundary tests for malformed/oversized/wrong-type/traversal/injection inputs | Not every parser needs fuzzing | Required when user-controlled input crosses trust boundary. |
| Tests use real seam | Test review, ban mocks of subject module, integration smoke for wiring | External services should be faked | Apply to bugfixes and integration-risk changes. |
| Dead code is retired | Knip/Vulture/Ruff/coverage/static reachability, build/typecheck, route manifests | Dynamic frameworks and public APIs create false positives | Use for cleanup/refactor, not blind deletion. |
| Weak types controlled | Typecheck, typed lint, no-explicit-any, strict modes, schema tests | Gradual migration may require scoped exceptions | Enforce on changed boundaries first. |
| Dependency cycles avoided | dependency-cruiser, Madge, import-linter, ESLint import rules | Some generated code or framework conventions may cycle | Use when architecture boundaries matter. |
| Artifacts deterministic | Regenerate twice and diff, golden tests, normalized timestamps/order/archive metadata | Some artifacts intentionally include time/randomness | Required for exports/manifests/packs/schemas/codegen. |
| API/export compatibility | Contract tests, schema diff, OpenAPI/GraphQL/client fixture diff | Generated clients need stable generation | Required for public or persisted contracts. |
| Scope drift visible | Diff review, formatter boundaries, touched-file lint, PR checklist | Big refactors can be legitimate | Use as review signal. |
| Long-task state survives | PR/issue/task checkpoint template, explicit handoff, progress log if repo uses one | Do not invent repo files without convention | Required for multi-session or broad tasks. |
