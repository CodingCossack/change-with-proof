---
name: agent-systems
description: Use when implementing, debugging, refactoring, testing, reviewing, or completing non-trivial software changes, especially across UI, APIs, auth, persistence, uploads, exports, routing, user input, secrets, external integrations, long-running tasks, cleanup, or ambiguous prototype-versus-contract boundaries.
---

# Agent Systems

This skill routes work into focused operating procedures. Repository and harness instructions, including `AGENTS.md` when present, remain authoritative; do not duplicate them here. Open only the files that match the current task.

## Routing protocol

1. If the change is trivial and low-risk, use normal repo conventions and final evidence reporting.
2. If the task is non-trivial, classify the mode and triggered risk surfaces.
3. Read the matching workflow files below.
4. Use references only when they clarify a decision, review, or enforcement choice.
5. Before handoff for any non-trivial code change, read `workflows/review-before-done.md`.

## Workflow triggers

| Trigger | Read |
|---|---|
| New work, prototype work, existing behaviour, scaffold/deletion, compatibility, or any uncertainty about what must be preserved | `workflows/mode-and-contracts.md` |
| Bug, failing test, runtime error, flaky behaviour, regression, or unexpected output | `workflows/debug-with-proof.md` + `workflows/proof-at-risk-seam.md` |
| Adding/changing/reviewing tests or deciding how to prove a change | `workflows/proof-at-risk-seam.md` |
| UI, product copy, exports, emails, notifications, end-user docs, user-facing logs, or visible generated content | `workflows/ui-product-boundary.md` |
| Auth, permissions, persistence, migrations, uploads, downloads, exports, manifests, routing, user-controlled input, secrets, payments, external APIs, webhooks, or generated artifacts | `workflows/high-risk-boundaries.md` |
| Refactor, cleanup, dead code, duplicate code/types, weak typing, circular dependencies, fallback/legacy removal, or agent slop | `workflows/cleanup-pass.md` |
| Long-running, multi-file, multi-step, compacted/resumed, or handoff-sensitive work | `workflows/long-running-tasks.md` |
| Completion, PR handoff, final review, or “is this done?” judgment | `workflows/review-before-done.md` |

## Common combinations

- UI route bug: `debug-with-proof` + `proof-at-risk-seam` + `ui-product-boundary` + `high-risk-boundaries` if routing/data/auth is involved.
- Export or manifest change: `mode-and-contracts` + `high-risk-boundaries` + `proof-at-risk-seam` + `review-before-done`.
- Prototype build: `mode-and-contracts` + `ui-product-boundary` if visible + `proof-at-risk-seam` for the smallest real-path proof.
- Cleanup/refactor in existing code: `mode-and-contracts` + `cleanup-pass` + `proof-at-risk-seam`.
- Long implementation: add `long-running-tasks` and checkpoint after each vertical slice.

## References

- `references/positive-patterns.md` — converts common “do not” rules into target behaviours.
- `references/review-catalog.md` — failure/smell catalogue with preferred responses.
- `references/enforcement-map.md` — maps invariants to tests, static checks, hooks, CI, and review mechanisms.
- `references/tooling.md` — tool categories and adoption notes; never a substitute for repo command discovery.

## Optional script

- `scripts/agent_hygiene_scan.sh` — advisory candidate scan with profiles. It is not proof, not a deletion authority, and not a CI gate unless a repo deliberately adopts it.
