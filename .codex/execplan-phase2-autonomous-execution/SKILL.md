---
name: execplan-phase2-autonomous-execution
description: Use this skill for Phase 2 long-horizon execution of a frozen ExecPlan with implementer explorer recorder and independent evaluator until PASS.
---

# ExecPlan Phase 2: Autonomous Execution

## Purpose

Use this skill after Phase 1 approval to execute a frozen ExecPlan with minimal user interruption and strict completion gates.

## Scope

This skill covers implementation, testing, evidence capture, and independent completion judgment.

## Session Start Rules

1. Initialize a fresh execution session.
2. Treat these as the only authoritative inputs:
   - Approved ExecPlan
   - AGENTS.md rules
   - Repository state
3. Do not expand scope unless the plan is formally updated and logged.

## Agent Responsibilities

- Implementer: code changes and test execution. Reports evidence, but cannot declare final completion.
- Explorer: targeted research and unknown resolution during execution.
- Recorder: mandatory plan maintenance at each stopping point.
- Evaluator: independent PASS/FAIL decision.

## Milestone Loop

1. Select next incomplete milestone from ExecPlan `Progress`.
2. Implementer executes planned edits and runs required tests.
3. Explorer resolves blockers or uncertainty as needed.
4. Recorder updates `Progress`, `Decision Log`, and `Surprises & Discoveries` with concrete evidence.
5. Evaluator checks completion gates and returns PASS/FAIL for the milestone.
6. On FAIL, convert findings into explicit remaining tasks and continue loop.

## Final Completion Gates

Evaluator must verify all conditions before final PASS:

- No unchecked required items in `Progress`
- DoD fully satisfied with evidence
- Required tests pass
- Plan, diff, and logs are consistent
- Remaining risks are documented and accepted

## Failure Recovery

When evaluator returns FAIL:

1. Recorder logs failed criteria and evidence.
2. Implementer creates remediation tasks in `Progress`.
3. Execute remediation and re-evaluate.

Repeat until evaluator returns final PASS.
