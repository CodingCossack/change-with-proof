# Positive Patterns

Use this to convert warning-label rules into target behaviours.

| Failure to avoid | Positive operating behaviour | Evidence to seek |
|---|---|---|
| Silent assumptions | Inspect authoritative sources, classify ambiguity by materiality, proceed only with local reversible assumptions. | Notes/report naming assumptions and sources inspected. |
| Confusion laundering | Keep observed facts, hypotheses, and confirmed causes separate. | Repro/log/trace plus stated confirmed cause. |
| Invented commands | Build a command inventory from repo files and CI; run the smallest authoritative check. | Command source and exact output. |
| Proofless completion | Scope every claim to evidence. | Claim/evidence/gap report. |
| Shallow simulation tests | Prove the invariant at the lowest seam containing the real risk. | Test/repro that would fail if the behaviour broke. |
| Excessive mocking | Use fakes only outside the seam being proven; encode boundary contracts. | Contract fixture or boundary fake plus real internal path. |
| Silent fallback | Define explicit success/error/degraded states. | Error-path tests, visible degraded state, or explicit thrown/returned error. |
| Speculative abstraction | Start direct; abstraction earns itself through real variants, boundaries, or reuse. | Simpler design or named invariant protected by abstraction. |
| Product/process leakage | Classify surface/audience and write visible output in domain/action language. | Rendered UI/export/email/doc proof. |
| Unrelated edits | Maintain diff locality: every hunk maps to invariant, fix, cleanup, or proof. | Review of changed files/hunks. |
| Dead-code buildup | Retire replaced paths and close references. | Dead-code/dependency/build/type/route checks where available. |
| Weak typing | Validate at boundary, narrow internally, use canonical schemas/types. | Typecheck, schema tests, invalid fixtures. |
| Fake compatibility | Preserve only contracts with provenance; delete accidental residue. | Contract inventory and migration/compatibility proof. |
| Long-task drift | Keep a resumable ledger of goal, decisions, proof, gaps, and next step. | Checkpoint/handoff state. |
| Artifact nondeterminism | Make generated output pure over declared inputs. | Regenerate/diff or golden proof. |
