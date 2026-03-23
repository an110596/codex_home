# Usage feedback rubric

Convert raw log evidence into actionable coaching feedback. Keep facts and inference explicitly separated.

## 1. Efficiency

Signals:
- Low completion ratio: many `task_started`, fewer `task_complete`
- Frequent `turn_aborted`
- Long-tail turn durations

Interpretation:
- Task framing may be too broad or acceptance criteria may be unclear.
- Interaction loop may be restarting instead of converging.

Recommended actions:
- Start requests with objective + constraints + done criteria in one message.
- Split large asks into 2-4 milestones and require checkpoint output after each.
- Add a "stop condition" (for example: "if blocked >2 attempts, summarize and ask").

## 2. Prompt quality

Signals:
- High rate of follow-up user messages before first successful completion
- Repeated clarification loops in `user_message` and `agent_message`
- Very short prompts with high abort/retry incidence

Interpretation:
- Missing context, constraints, or acceptance tests is driving rework.

Recommended actions:
- Use a fixed prompt skeleton: goal, scope, constraints, expected output, validation command.
- Include file paths and non-goals explicitly.
- Require a short plan before edits on complex tasks.

## 3. Tool strategy

Signals:
- Many `function_call_output` failures
- Repeated failures for same command pattern
- Heavy command volume with low task completion

Interpretation:
- Tool choice/order may be inefficient or risky for current sandbox/approval settings.

Recommended actions:
- Use read-first workflow before writes.
- Batch related reads with parallel-safe commands when possible.
- Replace flaky command patterns with stable scripts/queries.

## 4. Reliability and constraints

Signals:
- `ERROR`/`WARN` concentration in `log/codex-tui.log`
- Friction from sandbox or approval policy visible in `turn_context`
- File-not-found, permission, or network failures recurring

Interpretation:
- Environment constraints are limiting execution more than reasoning quality.

Recommended actions:
- Adapt commands to current sandbox/approval policy.
- Add preflight checks for required files/tools.
- Fail fast with explicit blocker summaries instead of repeated retries.

## 5. Token economy

Signals:
- Rapidly increasing `total_token_usage.total_tokens`
- High token cost in turns with no completion
- Long reasoning/output bursts with limited state change

Interpretation:
- Exploration depth is not aligned with task complexity.

Recommended actions:
- Add early scope narrowing and explicit success criteria.
- Summarize state every major step to avoid repeated rediscovery.
- Stop and re-plan if token burn grows without progress.

## Confidence and reporting rules

- Label each claim as `Fact` or `Inference`.
- Assign confidence (`High`, `Medium`, `Low`) based on evidence coverage:
  - `High`: repeated pattern across multiple turns/sessions.
  - `Medium`: strong pattern in one session or partial correlation.
  - `Low`: weak correlation or sparse data.
- Do not claim causality without direct evidence. State alternative explanations.

## Minimal recommendation format

For each top issue, output:
1. Observation (fact)
2. Why it matters (inference)
3. Change to try next session (specific instruction)
4. Metric to watch (for example completion ratio, abort count, failed tool calls, tokens per completion)
