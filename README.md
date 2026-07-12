# Agent Systems

[![Validate](https://github.com/CodingCossack/agent-systems/actions/workflows/validate.yml/badge.svg)](https://github.com/CodingCossack/agent-systems/actions/workflows/validate.yml)
[![Agent Skill](https://img.shields.io/badge/Agent%20Skill-compatible-111827)](https://agentskills.io/)
[![MIT License](https://img.shields.io/badge/license-MIT-2563eb)](LICENSE)

An agent-agnostic software engineering skill for implementation, debugging, testing, refactoring, security-sensitive boundaries, cleanup, verification, and code-review closeout.

Agent Systems routes coding agents into focused workflows based on the actual risk: contract preservation, root-cause debugging, proof selection, user-facing product boundaries, authentication and persistence, long-running work, or safe cleanup.

## Install

Install globally with the open [`skills`](https://github.com/vercel-labs/skills) CLI:

```sh
npx skills add CodingCossack/agent-systems -g -y
```

Install for selected agents:

```sh
npx skills add CodingCossack/agent-systems -g -y \
  -a codex -a claude-code -a gemini-cli -a opencode
```

The skill follows the open Agent Skills format and contains no harness-specific workflow dependency. It works with Codex, Claude Code, Gemini CLI, OpenCode, Cursor, GitHub Copilot CLI, Windsurf, and other compatible coding agents.

### Codex native installer

Ask Codex:

```text
$skill-installer install https://github.com/CodingCossack/agent-systems/tree/main/skills/agent-systems
```

### Manual installation

Keep a Git checkout outside the agent roots and link the actual skill directory:

```sh
git clone https://github.com/CodingCossack/agent-systems.git \
  ~/.local/share/agent-skills/agent-systems
mkdir -p ~/.agents/skills
ln -s ~/.local/share/agent-skills/agent-systems/skills/agent-systems \
  ~/.agents/skills/agent-systems
```

Restart an active agent session if it does not reload skills dynamically.

## Update

```sh
npx skills update agent-systems -g -y
```

For a Git installation:

```sh
git -C ~/.local/share/agent-skills/agent-systems pull --ff-only
```

## What it does

Agent Systems classifies non-trivial engineering work and loads only the procedures relevant to the current task:

| Risk or task | Workflow |
|---|---|
| Existing behaviour, prototypes, compatibility, contract uncertainty | Mode and contracts |
| Bugs, regressions, flaky tests, runtime errors | Debug with proof |
| Tests and verification strategy | Proof at the risk seam |
| UI, product copy, exports, emails, generated user content | UI and product boundary |
| Auth, persistence, uploads, routing, secrets, payments, external APIs | High-risk boundaries |
| Refactoring, dead code, weak typing, legacy removal | Cleanup and retirement |
| Multi-file, resumed, or handoff-sensitive work | Long-running tasks |
| Completion, final review, or PR handoff | Review before done |

The central rule is simple: prove the invariant at the lowest seam that still contains the real risk. A passing typecheck does not prove a browser flow; a unit test does not prove routing; a grep result is not deletion authority.

## Use

The skill is designed to trigger automatically for non-trivial software work. Explicit invocation also works:

```text
Use $agent-systems to debug this routing regression and prove the fix at the real failure seam.
```

```text
Use $agent-systems to implement this export change without breaking the existing schema contract.
```

```text
Use $agent-systems to review this refactor, remove accidental residue, and verify the affected behaviour before handoff.
```

Repository and harness instructions remain authoritative. If a repository has `AGENTS.md`, `CLAUDE.md`, contribution guidance, CI rules, or local conventions, the skill operates within them rather than replacing them.

## Advisory hygiene scanner

The bundled scanner finds candidates for review; it never authorises deletion and is not proof by itself.

```sh
./skills/agent-systems/scripts/agent_hygiene_scan.sh --profile fallback --include src
./skills/agent-systems/scripts/agent_hygiene_scan.sh --profile product --include app --include emails
./skills/agent-systems/scripts/agent_hygiene_scan.sh --profile types --include src
./skills/agent-systems/scripts/agent_hygiene_scan.sh --profile stale --include src
```

Run `./skills/agent-systems/scripts/agent_hygiene_scan.sh --help` for profiles and options from a repository checkout. After installation, use the scanner inside the installed `agent-systems` skill directory. The scanner requires [ripgrep](https://github.com/BurntSushi/ripgrep).

## Structure

```text
skills/agent-systems/
├── SKILL.md
├── agents/openai.yaml
├── workflows/
│   ├── mode-and-contracts.md
│   ├── debug-with-proof.md
│   ├── proof-at-risk-seam.md
│   ├── ui-product-boundary.md
│   ├── high-risk-boundaries.md
│   ├── cleanup-pass.md
│   ├── long-running-tasks.md
│   └── review-before-done.md
├── references/
│   ├── positive-patterns.md
│   ├── review-catalog.md
│   ├── enforcement-map.md
│   └── tooling.md
└── scripts/agent_hygiene_scan.sh
```

The router stays compact. Workflow and reference files are loaded only when their trigger matches the current task.

## Contributing

Focused issues and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) and [SECURITY.md](SECURITY.md).

## Licence

[MIT](LICENSE)
