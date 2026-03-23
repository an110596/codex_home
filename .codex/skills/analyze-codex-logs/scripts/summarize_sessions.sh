#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
SESSIONS_DIR="${ROOT%/}/sessions"

if [[ ! -d "$SESSIONS_DIR" ]]; then
  echo "sessions directory not found: $SESSIONS_DIR" >&2
  exit 1
fi

mapfile -t FILES < <(rg --files "$SESSIONS_DIR" -g '*.jsonl')
if [[ ${#FILES[@]} -eq 0 ]]; then
  echo "No session jsonl files found under $SESSIONS_DIR" >&2
  exit 1
fi

echo "# Session files"
printf 'count\t%d\n' "${#FILES[@]}"

echo

echo "# Top-level record types"
printf '%s\n' "${FILES[@]}" | xargs jq -r '.type' | sort | uniq -c

echo

echo "# event_msg payload types"
printf '%s\n' "${FILES[@]}" | xargs jq -r 'select(.type=="event_msg") | .payload.type // "<null>"' | sort | uniq -c

echo

echo "# response_item payload types"
printf '%s\n' "${FILES[@]}" | xargs jq -r 'select(.type=="response_item") | .payload.type // "<null>"' | sort | uniq -c
