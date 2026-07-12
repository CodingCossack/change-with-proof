# Review Before Done

Use before handoff, PR, final answer, or any claim that work is complete.

## 1. Diff locality

For each changed file or hunk, it should map to one of:

- Target invariant or requested behaviour.
- Root-cause fix.
- Required contract/migration update.
- Cleanup caused by the fix.
- Test/proof fixture.
- Mechanical/generated artifact intentionally updated.

Revert incidental formatting, renaming, comment churn, or nearby “improvements” unless they are required and stated.

## 2. Claim/evidence matching

Build the report around this question:

```text
Claim: <what I am saying is true>
Evidence: <check/repro/log/diff/trace proving it>
Gap: <what this evidence does not prove>
```

Do not let a broad claim outrun narrow evidence. “Typecheck passed” does not prove the browser flow. “Unit test passed” does not prove the route. “No grep hits” does not prove no dynamic references.

## 3. Command discovery review

When reporting checks, know where they came from:

- package/lock/task-runner files,
- CI config,
- README or repo docs,
- scripts,
- existing tests near the affected files.

If no authoritative command exists, say what you ran and why it is only partial proof. Do not add a new script just to make the report look clean unless the task includes creating repo enforcement.

## 4. Final report format

```text
Mode/contracts:
- <dead scaffold | active prototype | committed product surface | explicit contract; contracts changed/preserved>

Checks run:
- <command/repro/static check/browser path> → <result>

Proof:
- <evidence> → <claim it supports>

Gaps:
- <unverified risk, failed/skipped check, or uncertainty; "none" only when true>

Changed:
- <short summary of intentional changes and retired paths>
```

If checks failed, say failed. If nothing meaningful was verified, do not claim the implementation works.
