#!/usr/bin/env bash
set -euo pipefail

ROOT="${1:-.}"
LOG_FILE="${ROOT%/}/log/codex-tui.log"

if [[ ! -f "$LOG_FILE" ]]; then
  echo "log file not found: $LOG_FILE" >&2
  exit 1
fi

echo "# File"
echo "$LOG_FILE"

echo

echo "# Line count"
wc -l "$LOG_FILE"

echo

echo "# Level counts"
sed -E 's/\x1b\[[0-9;]*m//g' "$LOG_FILE" | rg -o ' (INFO|WARN|ERROR) ' | sort | uniq -c

echo

echo "# Recent 20 lines"
tail -n 20 "$LOG_FILE"
