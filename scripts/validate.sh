#!/usr/bin/env bash
set -euo pipefail

root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$root"
skill_dir="$root/skills/agent-systems"

command -v rg >/dev/null 2>&1 || {
  printf 'validation requires ripgrep (rg)\n' >&2
  exit 1
}

required=(
  skills/agent-systems/SKILL.md
  skills/agent-systems/agents/openai.yaml
  skills/agent-systems/workflows/mode-and-contracts.md
  skills/agent-systems/workflows/debug-with-proof.md
  skills/agent-systems/workflows/proof-at-risk-seam.md
  skills/agent-systems/workflows/ui-product-boundary.md
  skills/agent-systems/workflows/high-risk-boundaries.md
  skills/agent-systems/workflows/cleanup-pass.md
  skills/agent-systems/workflows/long-running-tasks.md
  skills/agent-systems/workflows/review-before-done.md
  skills/agent-systems/references/positive-patterns.md
  skills/agent-systems/references/review-catalog.md
  skills/agent-systems/references/enforcement-map.md
  skills/agent-systems/references/tooling.md
  skills/agent-systems/scripts/agent_hygiene_scan.sh
  README.md
  LICENSE
)

for path in "${required[@]}"; do
  [[ -f "$path" ]] || { printf 'missing required file: %s\n' "$path" >&2; exit 1; }
done

[[ "$(sed -n '2p' "$skill_dir/SKILL.md")" == 'name: agent-systems' ]] || {
  printf 'invalid or unexpected skill name\n' >&2
  exit 1
}

[[ "$(sed -n '3p' "$skill_dir/SKILL.md")" == description:\ Use\ when* ]] || {
  printf 'description must begin with "Use when"\n' >&2
  exit 1
}

[[ "$(sed -n '1p' "$skill_dir/SKILL.md")" == '---' && "$(sed -n '4p' "$skill_dir/SKILL.md")" == '---' ]] || {
  printf 'invalid frontmatter delimiters\n' >&2
  exit 1
}

while IFS= read -r path; do
  [[ -f "$skill_dir/$path" ]] || { printf 'broken SKILL.md reference: %s\n' "$path" >&2; exit 1; }
done < <(grep -oE '`(workflows|references|scripts)/[^`]+`' "$skill_dir/SKILL.md" | tr -d '`' | sort -u)

[[ -x "$skill_dir/scripts/agent_hygiene_scan.sh" ]] || {
  printf 'agent_hygiene_scan.sh must be executable\n' >&2
  exit 1
}

bash -n "$skill_dir/scripts/agent_hygiene_scan.sh"
"$skill_dir/scripts/agent_hygiene_scan.sh" --help >/dev/null

path_without_rg="$(mktemp -d)"
ln -s "$(command -v bash)" "$path_without_rg/bash"
set +e
PATH="$path_without_rg" /usr/bin/env bash "$skill_dir/scripts/agent_hygiene_scan.sh" --profile stale >/dev/null 2>&1
missing_rg_status=$?
set -e
rm -rf "$path_without_rg"
if [[ $missing_rg_status -ne 127 ]]; then
  printf 'missing ripgrep must exit 127; got %s\n' "$missing_rg_status" >&2
  exit 1
fi

for option in --profile --include --exclude; do
  set +e
  "$skill_dir/scripts/agent_hygiene_scan.sh" "$option" >/dev/null 2>&1
  option_status=$?
  set -e
  if [[ $option_status -ne 2 ]]; then
    printf '%s without a value must exit 2; got %s\n' "$option" "$option_status" >&2
    exit 1
  fi
done

set +e
"$skill_dir/scripts/agent_hygiene_scan.sh" --profile stale --include "$root/.missing-scan-path" >/dev/null 2>&1
missing_path_status=$?
set -e
if [[ $missing_path_status -eq 0 ]]; then
  printf 'missing include path must propagate ripgrep failure\n' >&2
  exit 1
fi

tmp="$(mktemp -d)"
trap 'rm -rf "$tmp"' EXIT
printf 'const value: any = input // TODO remove later\n' > "$tmp/sample.ts"
printf 'const generated: any = input // TODO exclude me\n' > "$tmp/sample.generated.ts"
printf 'function a() { return []; }\nfunction b() { return {}; }\n' > "$tmp/fallback.ts"
mkdir -p "$tmp/packages/app/node_modules/dependency"
printf 'const dependency: any = input // TODO ignore dependency\n' > "$tmp/packages/app/node_modules/dependency/index.ts"
"$skill_dir/scripts/agent_hygiene_scan.sh" --profile stale --include "$tmp" | grep -Fq 'sample.ts'
"$skill_dir/scripts/agent_hygiene_scan.sh" --profile types --include "$tmp" | grep -Fq 'sample.ts'
"$skill_dir/scripts/agent_hygiene_scan.sh" --profile fallback --include "$tmp" | grep -Fq 'fallback.ts'
if "$skill_dir/scripts/agent_hygiene_scan.sh" --profile stale --include "$tmp" | grep -Fq 'node_modules'; then
  printf 'nested dependency directory was not excluded\n' >&2
  exit 1
fi
excluded_output="$("$skill_dir/scripts/agent_hygiene_scan.sh" --profile stale --include "$tmp" --exclude '*.generated.ts')"
printf '%s\n' "$excluded_output" | grep -Fq 'sample.ts'
if printf '%s\n' "$excluded_output" | grep -Fq 'sample.generated.ts'; then
  printf 'user-supplied file glob was not preserved\n' >&2
  exit 1
fi

grep -Fq '$agent-systems' "$skill_dir/agents/openai.yaml" || {
  printf 'openai.yaml default prompt does not name the skill\n' >&2
  exit 1
}

grep -Fq 'agent-systems/tree/main/skills/agent-systems' README.md || {
  printf 'Codex native installer must target the nested skill directory\n' >&2
  exit 1
}

grep -Fq '.local/share/agent-skills/agent-systems/skills/agent-systems' README.md || {
  printf 'manual Git installation must link the nested skill directory\n' >&2
  exit 1
}

if find . -path ./.git -prune -o -type l -print | grep -q .; then
  printf 'repository payload must not contain symlinks\n' >&2
  exit 1
fi

if rg -n '/Users/|/home/[^ /]+/|docs/superpowers|subagent-driven-development|executing-plans' \
  --glob '!scripts/validate.sh' .; then
  printf 'private path or internal planning reference found\n' >&2
  exit 1
fi

printf 'Agent Systems validation passed.\n'
