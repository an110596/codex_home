- Write your reasoning and any code in English; respond to the user in Japanese. If there are separate instructions about language settings, follow those instructions.
- For user requests that involve investigating, thinking through, or troubleshooting, do not generate or modify code immediately.

## ExecPlan-Driven Long-Horizon Workflow

For multi-hour or high-risk tasks, operate in two phases with a mandatory ExecPlan.

### Phase 1 (Interactive Planning; user-facing)

- The main agent (`orchestrator`) must directly interact with the user to clarify requirements, constraints, priorities, scope, out-of-scope items, and Definition of Done (DoD).
- Create and finalize the first ExecPlan before implementation starts.
- Do not start implementation until the user explicitly approves the plan.

### Phase 2 (Fresh Session Execution; autonomous)

- Start a fresh execution session after Phase 1 approval.
- Treat the approved ExecPlan, this AGENTS.md, and repository state as the only authoritative inputs.
- Execute milestone-by-milestone with these roles:
  - `implementer`: implementation + required test execution
  - `explorer`: targeted investigation for unknowns/blockers
  - `recorder`: mandatory living-plan maintenance
  - `evaluator`: independent PASS/FAIL gate
- `implementer` cannot declare final completion.

### Mandatory Completion Gates

Final completion is allowed only when `evaluator` confirms all of the following:

- No required unchecked items remain in `Progress`
- DoD is fully satisfied with concrete evidence
- Required tests were run and passed
- ExecPlan updates, implementation diff, and reported outcomes are consistent

If evaluation fails, record gaps in ExecPlan and continue execution until PASS.

### Required Skills

- Use `execplan-phase1-dialog-planning` for Phase 1.
- Use `execplan-phase2-autonomous-execution` for Phase 2.
