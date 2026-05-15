# Spec Compliance Reviewer Prompt Template

Use when dispatching a `react-spec-reviewer` subagent.

## Template

```
Review this implementation against the task specification. You are a `react-spec-reviewer`.

## Task Specification
{TASK_SPEC}

## Implementation
Commit: {COMMIT_HASH}
Files changed: {FILE_LIST}

## Check Each Requirement
For each requirement in the task specification:
1. Is it implemented? (YES/NO)
2. If YES: Is the implementation correct?
3. If NO: What's missing?

## Check List
- [ ] All files in spec are created/modified
- [ ] All props/interfaces match spec types
- [ ] All behaviors described are implemented
- [ ] No extra features beyond spec scope

## Result
Respond with one of:
- **PASS** — All requirements met exactly
- **FAIL** — List specific gaps. Each gap must have: requirement → what's missing → what to fix
```
