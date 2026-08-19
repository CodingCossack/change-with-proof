# Change with Proof

[![Validate](https://github.com/CodingCossack/change-with-proof/actions/workflows/validate.yml/badge.svg)](https://github.com/CodingCossack/change-with-proof/actions/workflows/validate.yml)
[![Agent Skill](https://img.shields.io/badge/Agent%20Skill-compatible-111827)](https://agentskills.io/)
[![MIT License](https://img.shields.io/badge/license-MIT-2563eb)](LICENSE)

An agent-agnostic software engineering skill for implementation, debugging, refactoring,
testing, migration, and code review. It completes or reviews a non-trivial change without
letting compatibility, safety, or completion claims outrun evidence.

One core control loop (change contract → risk profiles → proof portfolio → execution →
completion gate) plus six composable risk profiles that are read only when their trigger
matches. This is v2, a breaking rewrite of the skill previously named `agent-systems`.
See [CHANGELOG.md](CHANGELOG.md) and [docs/design-rationale.md](docs/design-rationale.md).

## Install

Install globally with the open [`skills`](https://github.com/vercel-labs/skills) CLI:

```sh
npx skills add CodingCossack/change-with-proof -g -y
```

Install for selected agents:

```sh
npx skills add CodingCossack/change-with-proof -g -y \
  -a codex -a claude-code -a gemini-cli -a opencode
```

The skill follows the open Agent Skills format with no harness-specific dependency. It works
with Codex, Claude Code, Gemini CLI, OpenCode, Cursor, GitHub Copilot CLI, Windsurf, and
other compatible coding agents.

### Codex native installer

```text
$skill-installer install https://github.com/CodingCossack/change-with-proof/tree/main/skills/change-with-proof
```

### Manual installation

Keep a Git checkout outside the agent roots and link the actual skill directory:

```sh
git clone https://github.com/CodingCossack/change-with-proof.git \
  ~/.local/share/agent-skills/change-with-proof
mkdir -p ~/.agents/skills
ln -s ~/.local/share/agent-skills/change-with-proof/skills/change-with-proof \
  ~/.agents/skills/change-with-proof
```

Restart an active agent session if it does not reload skills dynamically.

## Update

```sh
npx skills update change-with-proof -g -y
```

For a Git installation:

```sh
git -C ~/.local/share/agent-skills/change-with-proof pull --ff-only
```

If updating across the v1→v2 rename, remove the old `agent-systems` links and re-link
`skills/change-with-proof` as shown above.

## Companion skill

[`anti-machinery`](https://github.com/CodingCossack/anti-machinery) governs what supporting
apparatus may remain after a task closes. The skills are independent, but work together:
`change-with-proof` owns contracts and evidence; `anti-machinery` owns the carrying cost of
tests, scripts, flags, adapters, reports, and other supporting machinery.

## What it does

The core `SKILL.md` owns the whole loop and is the only always-loaded file:

1. **Change contract** — classify what the change preserves, changes, migrates, or retires;
   how strong each contract is and who consumes it; how reversible the step is.
2. **Risk profiles** — read every profile whose trigger matches, none otherwise:

| Trigger | Profile |
|---|---|
| Bug, failing or flaky test, regression | `causal-debugging` |
| Changing/migrating/retiring a hard contract | `contract-evolution` |
| Identity, permissions, tenancy, secrets, untrusted input, uploads, routing | `trust-boundaries` |
| Persistence, retries, webhooks, payments, queues, caches | `stateful-integrations` |
| Rendering, copy, notifications, exports, user-facing output | `user-visible-surfaces` |
| Deletion, replacement, legacy removal | `replacement-closure` |

3. **Proof portfolio** — the smallest set of evidence that covers every material changed
   risk, each item chosen at the lowest seam that still contains the real risk.
4. **Execution** — vertical slices; one durable state block for long or resumed work.
5. **Completion gate** — diff locality, claim/evidence/gap matching, one compact report.

The central rule is unchanged from v1: a passing typecheck does not prove a browser flow, a
unit test does not prove routing, and a grep result is not deletion authority.

## Use

Explicit invocation:

```text
Use $change-with-proof to debug this routing regression and prove the fix at the real failure seam.
```

```text
Use $change-with-proof to migrate this schema without breaking existing rows, and report the evidence.
```

Repository and harness instructions remain authoritative. If a repository has `AGENTS.md`,
`CLAUDE.md`, CI rules, or local conventions, the skill operates within them.

Implicit invocation is enabled in `agents/openai.yaml` after the v2 trigger battery achieved
30/30 intended triggers and 0/30 near-miss triggers. On harnesses that route purely by
description (for example Claude Code), the frontmatter description carries the same explicit
"Do not use for" scope.

## Testing

Changes to the skill's behaviour are gated by subagent-based RED/GREEN pressure scenarios and
trigger micro-tests, recorded in [docs/testing.md](docs/testing.md). Structural checks run in
CI via `./scripts/validate.sh`.

## Structure

```text
skills/change-with-proof/
├── SKILL.md
├── agents/openai.yaml
└── profiles/
    ├── causal-debugging.md
    ├── contract-evolution.md
    ├── trust-boundaries.md
    ├── stateful-integrations.md
    ├── user-visible-surfaces.md
    └── replacement-closure.md
```

## Contributing

Focused issues and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) and
[SECURITY.md](SECURITY.md).

## Licence

[MIT](LICENSE)
