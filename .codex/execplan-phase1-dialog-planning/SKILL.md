---
name: execplan-phase1-dialog-planning
description: Use this skill for Phase 1 long-horizon planning with direct user dialogue requirement clarification risk discovery and first ExecPlan drafting and freeze before execution.
---

# ExecPlan Phase 1: Dialog Planning

## Purpose

Use this skill when the team is about to start a multi-hour task and needs a high-quality first ExecPlan before autonomous execution.

## Scope

This skill covers only Phase 1. It does not perform implementation.

## Workflow

1. Conduct direct dialogue with the user to capture goals, constraints, non-goals, priorities, deadlines, and acceptance expectations.
2. Convert ambiguous statements into explicit requirements. Confirm assumptions that affect architecture, safety, or delivery risk.
3. Ask an explorer agent for short investigations only when uncertainty cannot be resolved from current repo context.
4. Draft the first ExecPlan with clear milestones, concrete file paths, exact validation commands, and behavior-based acceptance criteria.
5. Define completion boundaries explicitly:
   - In scope
   - Out of scope
   - Definition of Done (DoD)
   - Allowed unfinished items (if any)
6. Record initial entries in `Progress`, `Decision Log`, `Surprises & Discoveries`, and `Outcomes & Retrospective`.
7. Obtain explicit user approval and freeze the plan for execution handoff.

## Required Outputs

Produce all of the following before ending Phase 1:

- Approved ExecPlan document
- Frozen scope and DoD section
- Initial risk register in `Decision Log`
- Explicit handoff note for Phase 2

## Quality Gates

Do not move to Phase 2 unless all checks pass:

- Requirements are testable and unambiguous
- Validation commands are runnable as written
- Acceptance criteria are observable behaviors
- Missing information is either resolved or listed as controlled risk

## Failure Recovery

If approval is blocked, return to dialogue and update the plan in-place. Never start implementation with an unapproved ExecPlan.
