# Long-Running Task Workflow

Use for multi-step, multi-file, resumed, compacted, exploratory, or handoff-sensitive work.

## Task ledger

Maintain this state mentally for short tasks and durably for long or multi-session work:

```text
Original goal:
Active invariant:
Mode and contracts:
Non-goals:
Current slice:
Files intentionally touched:
Decisions made:
Rejected approaches:
Proof run:
Proof still needed:
Known gaps:
Next smallest step:
Stop condition:
```

## Checkpoint triggers

Re-establish the ledger:

- At the start of a long task.
- After context compaction or session resumption.
- Before changing a contract or high-risk boundary.
- After each meaningful vertical slice.
- After failed verification or a surprising result.
- After discovering a new risk surface.
- Before broad cleanup or refactor.
- Before final handoff.

## Durable state

For multi-session work, use an existing issue, PR description, task document, progress file, or repo-approved state surface when available. If no approved location exists, include a resumable handoff in the final response. Do not create new repo state files unless the user or repo convention asks for them.

Never place task-state notes, agent reasoning, implementation TODOs, or checkpoint text into product-facing UI, exports, emails, or end-user docs.

## Vertical slices

Prefer thin slices that produce runnable or reviewable behaviour:

```text
slice goal → implementation → proof → cleanup → checkpoint
```

Planning/checkpoint text is not progress unless it reduces uncertainty, preserves resumable state, verifies behaviour, or enables the next implementation step.

## Partial completion

When stopping before everything is done, distinguish:

- Usable/executable behaviour now.
- Scaffolding or structure that is not yet behaviour.
- Proof already run.
- Risks and proof still missing.
- The next smallest step.

## Resumption

After compaction or a new session, resume only from repo-visible facts, current diff, test output, logs, explicit task artifacts, or a previous handoff. Do not reconstruct requirements from vague memory.
