# Session log query cheatsheet

Use these commands for `sessions/**/rollout-*.jsonl`.

## List all top-level record types

```bash
FILES=$(rg --files sessions -g '*.jsonl')
echo "$FILES" | xargs jq -r '.type' | sort | uniq -c
```

## Count `event_msg.payload.type`

```bash
FILES=$(rg --files sessions -g '*.jsonl')
echo "$FILES" | xargs jq -r 'select(.type=="event_msg") | .payload.type' | sort | uniq -c
```

## Count `response_item.payload.type`

```bash
FILES=$(rg --files sessions -g '*.jsonl')
echo "$FILES" | xargs jq -r 'select(.type=="response_item") | .payload.type' | sort | uniq -c
```

## Extract tool call errors (`function_call_output` contains non-zero exit hints)

```bash
FILES=$(rg --files sessions -g '*.jsonl')
echo "$FILES" | xargs jq -r '
  select(.type=="response_item" and .payload.type=="function_call_output")
  | [.timestamp, .payload.call_id, .payload.output]
  | @tsv
' | rg -n "Process exited with code [1-9]"
```

## Get aborted turns

```bash
FILES=$(rg --files sessions -g '*.jsonl')
echo "$FILES" | xargs jq -r '
  select(.type=="event_msg" and .payload.type=="turn_aborted")
  | [.timestamp, .payload.turn_id, .payload.reason]
  | @tsv
'
```

## Turn lifecycle counts (start/complete/abort)

```bash
FILES=$(rg --files sessions -g '*.jsonl')
echo "$FILES" | xargs jq -r '
  select(.type=="event_msg" and (.payload.type=="task_started" or .payload.type=="task_complete" or .payload.type=="turn_aborted"))
  | .payload.type
' | sort | uniq -c
```

## Turn duration by `turn_id` (seconds)

```bash
FILES=$(rg --files sessions -g '*.jsonl')
jq -s -r '
  map(select(.type=="event_msg" and (.payload.type=="task_started" or .payload.type=="task_complete")))
  | map({turn_id: .payload.turn_id, evt: .payload.type, ts: .timestamp})
  | map(select(.turn_id != null))
  | group_by(.turn_id)
  | map(
      select((map(.evt) | index("task_started")) and (map(.evt) | index("task_complete")))
      | {
          turn_id: .[0].turn_id,
          start: (map(select(.evt=="task_started") | .ts) | min),
          end: (map(select(.evt=="task_complete") | .ts) | max)
        }
      | . + {duration_sec: ((.end | fromdateiso8601) - (.start | fromdateiso8601))}
    )
  | sort_by(.duration_sec)
  | .[]
  | [.turn_id, (.duration_sec | tostring)]
  | @tsv
' $FILES
```

## Most expensive token checkpoints (descending)

```bash
FILES=$(rg --files sessions -g '*.jsonl')
echo "$FILES" | xargs jq -r '
  select(.type=="event_msg" and .payload.type=="token_count")
  | {
      ts: .timestamp,
      turn_id: (.payload.turn_id // "<none>"),
      total: (.payload.info.total_token_usage.total_tokens // null)
    }
  | select(.total != null)
  | [.ts, .turn_id, (.total|tostring)]
  | @tsv
' | sort -k3,3nr | head -n 20
```

## User message length distribution (proxy for prompt specificity)

```bash
FILES=$(rg --files sessions -g '*.jsonl')
echo "$FILES" | xargs jq -r '
  select(.type=="event_msg" and .payload.type=="user_message")
  | (.payload.message // "")
  | length
' | awk '
  { n++; s+=$1; if($1<80) a++; else if($1<250) b++; else c++; }
  END {
    if (n==0) { print "no user_message records"; exit 0 }
    printf("count=%d avg_len=%.1f short(<80)=%d medium(80-249)=%d long(>=250)=%d\n", n, s/n, a, b, c)
  }
'
```
