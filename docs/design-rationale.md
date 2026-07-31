# Design rationale (v2)

Why v2 looks the way it does. Operational rules live in the skill itself; this file only
records the reasoning so future contributors do not re-litigate or silently revert it.

## One core loop instead of a keyword router

v1 routed through a trigger table plus "common combinations". The combinations contradicted
the table (the export example omitted the UI workflow its own trigger row demanded), and a
single UI-route bug could match six or seven workflows with no rule for which instruction won.
v2 keeps one always-loaded control loop and moves risk-specific obligations into profiles with
a deterministic rule: read the union of matching profiles, nothing else. Profiles never
restate loop rules, so there is nothing to conflict.

## Three contract fields instead of four modes

v1's modes (dead scaffold, active prototype, committed product surface, explicit contract)
were not mutually exclusive — a prototype can hold persisted user data; a product surface can
be an explicit contract; "dead" is a conclusion that needs evidence, not a mode. Disposition,
strength-with-provenance, and reversibility are orthogonal and jointly cover the same
decisions. We deliberately stopped at three fields (an external review proposed six): each
extra field is template weight on every task, and uncertainty is better carried as one
assumptions line.

## Proof portfolio instead of a single proof seam

"Prove the invariant at the lowest seam that still contains the real risk" assumed one
invariant and one seam. Real changes carry several risk edges (API compatibility AND
navigation AND migration), each needing its own evidence. The v1 seam-taxonomy table was the
best content in the skill and is preserved verbatim; only the selection rule changed.

## One state block, one report

v1 defined six structured output blocks across five files (mode output, RED/GREEN report,
boundary protocol, task ledger, claim/evidence/gap, final report). Agents emitted process
scaffolding instead of solving tasks, and the same state had several subtly different
representations. v2 has exactly one optional state block (long/resumed work) and one final
report, with "omit empty sections" stated once.

## Why the references and the scanner were deleted

`positive-patterns.md`, `review-catalog.md`, and `enforcement-map.md` restated the same
themes (silent fallback, weak types, shallow tests, scope drift) three to four times in
different table shapes — instruction drift risk with no added capability. `tooling.md` was a
generic ecosystem catalogue that ages independently of the skill; repositories name their own
tools. The hygiene scanner's patterns matched every `catch`/`except`/`rescue`, every
`return true/false/[]/{}/null`, and the bare word `any` — in Python files this includes the
builtin `any()`. A targeted `rg` chosen from repository context beats a fixed noisy pattern
set; a scanner worth shipping needs language-aware checks, suppression, machine-readable
output, and measured precision, which is a separate project.

## Why behavioral testing is subagent-based, not an eval harness

The RED baseline (docs/testing.md) showed capable agents already avoid most gross failures
with or without v1; the skill's measurable value is narrower (proof artifacts, counterfactual
discipline, decision-surfacing) and its measurable cost is context weight and trigger false
fires. Pressure scenarios with fixture repos catch regressions in exactly those behaviours at
a fraction of the cost of a bespoke eval harness. A fixture-repo eval suite with repeated runs
remains future work if the skill grows users.

## Trigger control starts with the description

`allow_implicit_invocation: true` lets harnesses that read `agents/openai.yaml` route to the
skill automatically. Claude Code and similar harnesses route purely on the frontmatter
description, so the description remains the cross-harness control: positive triggers list
what the skill actually handles (v1 omitted payments, webhooks, migrations, and permissions
that its own router claimed), and the "Do not use for" clause removes the only false fires
observed in baseline trigger tests (dedicated security audits, visual design). The v2 trigger
battery justified implicit routing with 30/30 intended triggers and 0/30 near-miss triggers.
