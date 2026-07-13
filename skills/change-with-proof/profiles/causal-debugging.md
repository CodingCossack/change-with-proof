# Causal Debugging

## Trigger

An observed failure: bug, failing or flaky test, regression, runtime error, or unexpected
output.

## Additional obligations

- Capture the observed fact exactly (command output, stack trace, route, input, log, failing
  assertion) and the broken invariant — what should be true but is not. Keep facts separate
  from guesses until verified.
- Decompose before fixing: **trigger** (the input or state that starts it), **defect** (the
  wrong code or data), **propagation** (how it travels to the visible symptom), **detection
  gap** (why nothing caught it earlier).
- Root-cause gate: before claiming a confirmed cause, run a discriminating experiment — an
  intervention that behaves differently under your hypothesis than under rivals. The standard
  form is the counterfactual: the same repro fails before the fix and passes after it.
  Reading code until a line looks wrong produces a hypothesis, not a confirmation.
- Build the smallest deterministic repro first; stabilize clocks, randomness, network,
  concurrency, and data when relevant. For flaky failures, make the failure reproducible or
  tightly bounded before fixing — one green run is not proof.
- Fix the owner of the defect, not a symptom wrapper. When the defect lives in wiring,
  routing, persistence, serialization, auth, or UI behaviour, prove through that real seam,
  not only a mocked helper.
- Close the detection gap when cheap: leave the RED test in place at the seam that missed the
  bug.
- Adjacent defects discovered on the way go to gaps/follow-ups unless they share the same root
  cause and proof path.

## Characteristic failure modes

- Cause claimed from inspection alone, then "verified" by the same reasoning that produced it.
- Symptom patched (retry, guard, default value) while the defect stays live upstream.
- Fix proven only through a mocked helper when the bug lived in real wiring or routing.
- Flaky test declared fixed after a single green run.
- Unrelated fixes bundled into the bugfix diff.

## Minimum evidence

- The counterfactual pair: the same test/repro fails pre-fix and passes post-fix — or, when
  automation is infeasible, the strongest deterministic repro plus a named automation gap.
- For non-trivial bugs, the trigger / defect / propagation / detection-gap statement.

## Exit criteria

- The defect owner changed, not a wrapper around it.
- Causality demonstrated by intervention, not correlation.
- Detection gap closed or explicitly named as a gap.
- Adjacent defects logged, not silently folded in.
