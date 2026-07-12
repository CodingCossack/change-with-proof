# Debug With Proof Workflow

Use for bugs, failing tests, regressions, flaky behaviour, runtime errors, or unexpected output.

## Diagnosis loop

1. **Observed fact:** capture the exact failure: command output, stack trace, route, input, screenshot, log, failing assertion, or user report.
2. **Broken invariant:** state what should be true but is not.
3. **Hypotheses:** list likely causes as hypotheses, not facts.
4. **Reproduction:** create or identify the smallest deterministic repro. Stabilize clocks, randomness, network, concurrency, and data when relevant.
5. **Confirmed cause:** inspect enough code/data to connect the failure to one cause.
6. **Proof seam:** choose the seam that would fail before the fix and pass after it.
7. **Minimal fix:** change the owner of the bug, not a symptom wrapper.
8. **Re-run proof:** run the same repro/check and any affected contract checks.

## Rules for useful debugging

- Do not patch symptoms before naming the broken invariant.
- Keep observed facts separate from guesses until verified.
- If the bug is in wiring, routing, persistence, serialization, auth, or UI behaviour, prove through that real seam rather than only a mocked helper.
- If a true RED test is infeasible, use a deterministic repro and state the automation gap.
- If adjacent defects appear, add them to gaps/follow-up unless they share the same root cause and proof path.
- For flaky bugs, first make the failure reproducible or tightly bounded; a green run alone is not proof.

## RED/GREEN evidence

Preferred report:

```text
Before: <test/repro/check> failed because <observed failure>
Fix: <smallest owner change>
After: <same test/repro/check> passes and proves <invariant>
Remaining gap: <none or exact gap>
```
