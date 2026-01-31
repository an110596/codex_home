#!/usr/bin/env sh
set -eu

json="${1-}"

if ! command -v jq >/dev/null 2>&1; then
  exit 0
fi

type="$(printf '%s' "$json" | jq -r '.type // empty')"
[ "$type" = "agent-turn-complete" ] || exit 0

title="Codex: Turn complete"
message=""

last="$(printf '%s' "$json" | jq -r '."last-assistant-message" // empty')"
if [ -n "$last" ]; then
  title="Codex: $last"
fi

msg="$(printf '%s' "$json" | jq -r '."input-messages" // empty | if type=="array" then join(" ") else tostring end')"
if [ -n "$msg" ] && [ "$msg" != "null" ]; then
  message="$msg"
fi

sanitize() {
  printf '%s' "$1" | tr '\n' ' ' | tr -d '\033\007'
}

title="$(sanitize "$title")"
message="$(sanitize "${message:-}")"

if [ -z "${message:-}" ]; then
  message="Codex turn complete"
fi

printf '\033]777;notify;%s;%s\007' "$title" "$message"
