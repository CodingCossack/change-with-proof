# Contributing

Small corrections (typos, broken links, formatting) can go directly to a pull request.

A material change to instructions or triggers must:

1. name the failure mode it addresses — what an agent does wrong without it;
2. add or update a scenario or trigger case in `docs/testing.md` that distinguishes the
   proposed behaviour from the current baseline (RED/GREEN);
3. pass `./scripts/validate.sh`.

Keep contributions:

- agent-agnostic: no harness-specific tool names, repository-specific policies, or private
  paths;
- single-sourced: every rule lives in `SKILL.md` exactly once;
- evidence-bound: a rule that no observed failure or measured delta justifies does not go
  in, however plausible (see docs/design-rationale.md);
- positive: define target behaviour connected to an observable risk, contract, or proof seam
  rather than generic prohibitions.
