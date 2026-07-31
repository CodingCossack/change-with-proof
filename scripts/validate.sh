#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"

fail() { printf 'FAIL: %s\n' "$1" >&2; exit 1; }

required=(
  README.md
  LICENSE
  CONTRIBUTING.md
  SECURITY.md
  CHANGELOG.md
  docs/design-rationale.md
  docs/testing.md
  scripts/check_skill.py
  .github/workflows/validate.yml
  skills/change-with-proof/SKILL.md
  skills/change-with-proof/agents/openai.yaml
  skills/change-with-proof/profiles/causal-debugging.md
  skills/change-with-proof/profiles/contract-evolution.md
  skills/change-with-proof/profiles/trust-boundaries.md
  skills/change-with-proof/profiles/stateful-integrations.md
  skills/change-with-proof/profiles/user-visible-surfaces.md
  skills/change-with-proof/profiles/replacement-closure.md
)
for f in "${required[@]}"; do
  [[ -f "$f" ]] || fail "missing required file: $f"
done

# v1 leftovers must not survive the migration
banned=(
  skills/agent-systems
  skills/change-with-proof/references
  skills/change-with-proof/scripts
  skills/change-with-proof/workflows
)
for p in "${banned[@]}"; do
  [[ ! -e "$p" ]] || fail "v1 leftover present: $p"
done

python3 scripts/check_skill.py || fail "check_skill.py reported errors"

grep -Fq '$change-with-proof' skills/change-with-proof/agents/openai.yaml \
  || fail 'openai.yaml must reference $change-with-proof'
grep -Fq 'allow_implicit_invocation: true' skills/change-with-proof/agents/openai.yaml \
  || fail 'openai.yaml must enable implicit invocation'

grep -Fq 'skills/change-with-proof' README.md \
  || fail 'README must document the skills/change-with-proof payload path'
grep -Fq 'CodingCossack/agent-systems' README.md \
  || fail 'README must document the install source repo'

[[ -z "$(git ls-files -s | awk '$1 == "120000"')" ]] \
  || fail 'tracked symlinks are not allowed'

# No private absolute paths in tracked content (this script excluded: the
# pattern below appears in it as a string).
if git grep -nE '/Users/|/home/[^ /]+/' -- . ':!scripts/validate.sh' >/dev/null 2>&1; then
  git grep -nE '/Users/|/home/[^ /]+/' -- . ':!scripts/validate.sh' >&2 || true
  fail 'private absolute paths found in tracked files'
fi

printf 'change-with-proof validation passed.\n'
