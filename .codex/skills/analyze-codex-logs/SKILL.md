---
name: analyze-codex-logs
description: Analyze Codex CLI logs in `log/` and `sessions/` to produce evidence-backed usage feedback, not only format-level diagnostics. Use when reviewing how Codex is used, reducing retries/aborts/tool failures, improving prompt quality, controlling token usage, or preparing repeatable coaching reports from local runs.
---

# Analyze Codex Logs

Analyze local Codex logs with a repeatable workflow. Start with format-safe summaries, then map observed patterns to high-level coaching feedback.

## Workflow

1. Confirm scope.
- Target `log/codex-tui.log` and `sessions/**/rollout-*.jsonl`.
- Do not read unrelated secrets. If the user bans specific files (for example `auth.json`), respect that ban.
- Confirm time range, target project, and whether the user wants one session or trend analysis.

2. Load format references.
- Read `references/session_record.schema.json` for JSONL record structure.
- Read `references/codex_tui_log_line.schema.json` and `references/codex_tui_log_format.md` for text log parsing.
- Read `references/session_queries.md` for ready-made `jq` queries.
- Read `references/usage_feedback_rubric.md` to convert raw events into coaching feedback.

3. Run baseline summaries.
- Run `scripts/summarize_sessions.sh <root>` to count record categories.
- Run `scripts/summarize_tui_log.sh <root>` to get level counts and recent lines.
- Run focused queries from `references/session_queries.md` for turn lifecycle, tool outcomes, and token trends.

4. Derive coaching signals by dimension.
- Workflow efficiency: quantify completion rate, abort rate, and turn duration outliers.
- Prompt quality: inspect user-message patterns that correlate with retries, aborts, or long turns.
- Tool strategy: measure function-call volume, non-zero exits, and repeated failing call patterns.
- Reliability and constraints: inspect `WARN`/`ERROR`, approval/sandbox context, and environment friction.
- Token economy: track token accumulation and identify expensive turns with weak progress signals.

5. Report findings and recommendations.
- Separate facts from inference.
- Quote concrete evidence with timestamp, record type, and key IDs (`turn_id`, `call_id`, `thread_id`).
- For each finding, include one specific behavior change for the next run.
- Prioritize top 3 actions by expected impact and implementation effort.

## Output Template

Use this structure unless the user asks for a different format.

- Scope: files and date range analyzed.
- Executive summary: top issues and likely impact on speed/quality.
- Scorecard: efficiency, prompt quality, tool strategy, reliability, token economy (1-5 with confidence).
- Key findings: ordered by severity.
- Evidence: exact timestamps + identifiers, plus fact/inference label.
- Recommended actions: concrete next-session instructions (copyable).
- Experiment plan: what to change first and what metric should improve.
- Open questions: missing data or ambiguity.
- Next checks: concrete commands to reduce uncertainty.

## Resources

- `references/session_record.schema.json`: JSON Schema for one `sessions` JSONL record.
- `references/codex_tui_log_line.schema.json`: regex schema for one `codex-tui.log` line.
- `references/codex_tui_log_format.md`: parser notes and message categorization.
- `references/session_queries.md`: copy-paste query set.
- `references/usage_feedback_rubric.md`: signal-to-feedback mapping and recommendation rules.
- `scripts/summarize_sessions.sh`: baseline summary for `sessions`.
- `scripts/summarize_tui_log.sh`: baseline summary for `codex-tui.log`.
