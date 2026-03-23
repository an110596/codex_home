# codex-tui.log format

## 1) Raw line structure

Each line is a single log event.

```text
[timestamp] [level] [context/module and message]
```

Observed timestamp format: RFC3339 UTC (`...Z`), with optional fractional seconds.

Examples:

```text
2026-03-23T13:36:15.112880Z  INFO session_loop{thread_id=...}:submission_dispatch{...}: codex_core::codex: new
\x1b[2m2025-09-18T03:51:02.052041Z\x1b[0m \x1b[31mERROR\x1b[0m Failed to read auth.json: No such file or directory (os error 2)
```

## 2) Regex for parsing (named captures)

Use ANSI-stripped parsing first for better stability.

```regex
^(?:\x1b\[[0-9;]*m)?(?<timestamp>\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?Z)(?:\x1b\[[0-9;]*m)?\s+(?:\x1b\[[0-9;]*m)?(?<level>INFO|WARN|ERROR)(?:\x1b\[[0-9;]*m)?\s+(?<rest>.*)$
```

Then split `rest` heuristically:

- If `rest` contains `: `, treat the last `: ` separator as boundary between `prefix` and `message`.
- `prefix` typically includes tracing context and Rust module path.

## 3) Common message categories

- Lifecycle: `new`, `close time.busy=... time.idle=...`, `Shutting down Codex instance`
- Tool trace: `ToolCall: ...`
- Failures/warnings: state migration warnings, file-not-found, unexpected response item
