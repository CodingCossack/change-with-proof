# Change with Proof

[![Validate](https://github.com/CodingCossack/change-with-proof/actions/workflows/validate.yml/badge.svg)](https://github.com/CodingCossack/change-with-proof/actions/workflows/validate.yml)
[![Agent Skill](https://img.shields.io/badge/Agent%20Skill-compatible-111827)](https://agentskills.io/)
[![MIT License](https://img.shields.io/badge/license-MIT-2563eb)](LICENSE)

An agent skill that stops a coding agent's claims from outrunning its evidence when it
changes software that already has behaviour worth preserving.

Capable agents already fix most bugs. What they still get wrong, under pressure, are a
handful of judgement calls around the fix:

- **"Fixed"** without a regression test at the seam that actually missed the bug, or
  without showing the same check failing before the fix and passing after it.
- **"Backwards compatible"** by quietly enshrining an accident — a typo route, an
  unintended fallback — behind a speculative "someone may depend on it".
- **"Resilient"** by silently changing business behaviour: substituted prices or rates,
  skipped writes, placeholder data shipped as a default instead of surfaced as a decision.
- **"Done"** on evidence of the wrong scope: a typecheck offered as proof of a browser
  flow, a mocked-helper test as proof of routing, "no grep hits" as proof of no consumers.

The skill is one short file (~620 words) that makes those calls explicit: decide each
touched behaviour's contract before editing, prove each changed risk at the seam that
carries it, and gate the claim of done on matching-scope evidence or a named gap.

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

If updating from v2, note that the `profiles/` directory no longer exists; a plain
`git pull` handles this, but copies made by hand should be replaced whole.

## Use

The frontmatter description routes the skill automatically on harnesses with implicit
skill invocation (it fires on changes to existing behaviour and stays out of Q&A,
greenfield scaffolding, prompt writing, security audits, and visual design). Explicit
invocation also works:

```text
Use $change-with-proof to debug this routing regression and prove the fix at the real failure seam.
```

Repository and harness instructions remain authoritative. If a repository has `AGENTS.md`,
`CLAUDE.md`, CI rules, or local conventions, the skill operates within them.

## Companion skill

[`anti-machinery`](https://github.com/CodingCossack/anti-machinery) governs what supporting
apparatus — tests, harnesses, flags, scripts — may remain once a task closes. The skills are
independent: `change-with-proof` decides what must change and what evidence proves it;
`anti-machinery` decides what may still exist afterwards.

## Testing

Changes to the skill's behaviour are gated by pressure scenarios run against real coding
agents on fixture repositories, with no-skill and previous-version controls, plus trigger
micro-tests for the activation description. Results are recorded in
[docs/testing.md](docs/testing.md); design decisions and their evidence live in
[docs/design-rationale.md](docs/design-rationale.md). Structural checks run in CI via
`./scripts/validate.sh`.

## Structure

```text
skills/change-with-proof/
├── SKILL.md
└── agents/openai.yaml
```

## Contributing

Focused issues and pull requests are welcome. See [CONTRIBUTING.md](CONTRIBUTING.md) and
[SECURITY.md](SECURITY.md).

## Licence

[MIT](LICENSE)
