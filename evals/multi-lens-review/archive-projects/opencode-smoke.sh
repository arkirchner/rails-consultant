#!/usr/bin/env bash
set -euo pipefail

case_dir=$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)
root=$(git -C "$case_dir" rev-parse --show-toplevel)
results="$root/evals/results/opencode-archive-projects"
mkdir -p /tmp/opencode "$results"
work=$(mktemp -d /tmp/opencode/archive-projects.XXXXXX)
trap 'rm -rf -- "$work"' EXIT

(
  cd "$work"
  bash "$case_dir/fixture.sh"
)
head_before=$(git -C "$work" rev-parse HEAD)

mkdir -p "$work/.opencode/skills"
cp -R "$root/skills/multi-lens-review" "$work/.opencode/skills/"
cat > "$work/opencode.json" <<'JSON'
{
  "$schema": "https://opencode.ai/config.json",
  "default_agent": "build",
  "permissions": [
    { "action": "skill", "resource": "*", "effect": "deny" },
    { "action": "skill", "resource": "multi-lens-review", "effect": "allow" },
    { "action": "edit", "resource": "*", "effect": "deny" },
    { "action": "question", "resource": "*", "effect": "deny" }
  ]
}
JSON
printf '/.opencode/\n/opencode.json\n' >> "$work/.git/info/exclude"

prompt=$(awk 'NR > 1 && $0 == "---" { body = 1; next } body { print }' "$case_dir/prompt.md")
trace="$results/trace.jsonl"
reply="$results/reply.txt"
stderr="$results/stderr.log"

printf 'Running the OpenCode review (40-minute timeout). Results: %s\n' "$results"
if (cd "$work" && timeout 2400 opencode run --archived --format json "$prompt") > "$trace" 2> "$stderr"; then
  :
else
  status=$?
  cat "$stderr" >&2
  printf 'OpenCode exited with status %d. Trace: %s\n' "$status" "$trace" >&2
  exit "$status"
fi
jq -r 'select(.type == "text") | .part.text' "$trace" > "$reply"

failures=0

pass() {
  printf 'PASS %s\n' "$1"
}

fail() {
  printf 'FAIL %s\n' "$1" >&2
  failures=$((failures + 1))
}

check_reply() {
  local label=$1
  local pattern=$2
  if grep -Eiq -- "$pattern" "$reply"; then
    pass "$label"
  else
    fail "$label"
  fi
}

if jq -e 'select(.type == "tool_use" and .part.tool == "skill" and .part.state.input.id == "multi-lens-review")' "$trace" > /dev/null; then
  pass 'loads multi-lens-review'
else
  fail 'loads multi-lens-review'
fi

check_reply 'finds the SPEC in specs/' 'specs/archive-projects\.md'
check_reply 'finds the missing ownership check' 'another user|other users|ownership|belongs to|unauthori[sz]ed|signed-in user'
check_reply 'flags the unrequested email' 'ProjectMailer|archive email|archived email'
check_reply 'asks which findings to apply' 'which.*(findings|fixes).*(apply|fix)|which.*apply|findings.*apply'

if jq -e 'select(.type == "tool_use" and (.part.tool == "edit" or .part.tool == "write" or .part.tool == "patch"))' "$trace" > /dev/null; then
  fail 'uses no edit tools'
else
  pass 'uses no edit tools'
fi

if [[ $(git -C "$work" rev-parse HEAD) == "$head_before" && -z $(git -C "$work" status --porcelain) ]]; then
  pass 'leaves the fixture unchanged'
else
  fail 'leaves the fixture unchanged'
fi

printf '\nReply: %s\nTrace: %s\n' "$reply" "$trace"
if ((failures > 0)); then
  printf '\n--- Review reply ---\n' >&2
  cat "$reply" >&2
  exit 1
fi
