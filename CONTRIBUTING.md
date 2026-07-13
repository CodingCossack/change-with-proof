# Contributing

Small corrections (typos, broken links, formatting) can go directly to a pull request.

A material change to instructions, triggers, or profiles must:

1. name the failure mode it addresses — what an agent does wrong without it;
2. add or update a scenario or trigger case in `docs/testing.md` that distinguishes the
   proposed behaviour from the current baseline (RED/GREEN);
3. pass `./scripts/validate.sh`.

Keep contributions:

- agent-agnostic: no harness-specific tool names, repository-specific policies, or private
  paths;
- single-sourced: control-loop rules live in `SKILL.md` once; profiles add only obligations
  for their risk class and follow the fixed section contract (Trigger / Additional
  obligations / Characteristic failure modes / Minimum evidence / Exit criteria);
- positive: define target behaviour connected to an observable risk, contract, or proof seam
  rather than generic prohibitions.
