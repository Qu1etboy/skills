---
name: implement
description: >
  Implement a resolved spec against the current codebase. Use only when the
  user explicitly provides a spec or implementation brief and asks to implement
  it. Inspect the repository before coding, surface material conflicts or gaps,
  then implement using the software-engineer skill.
argument-hint: "<spec>"
model: claude-sonnet-5
effort: medium
---

# Implement

Implement the provided spec as an engineer, not a compiler.

## Preflight

Before changing code:

1. Read the spec.
2. Inspect the relevant current code and trace the real flow.
3. Compare the spec's assumptions with repository reality.

The spec's explicit design decisions are settled. Do not reopen them just
because another design might be better.

Surface before implementation when you find:

- a material contradiction between the spec and repository,
- unexpectedly large scope because assumed infrastructure or patterns do not exist,
- a missing failure mode or design gap requiring a meaningful decision.

Resolve small, obvious gaps yourself when there is one low-risk answer
consistent with the spec and existing code.

Do not manufacture concerns. A possible improvement is not a finding.

## Implement

Once preflight passes, implement the spec completely.

Follow the /software-engineer skill for how to change code.

Preserve the spec's intent, follow repository conventions, fill obvious gaps,
and do not add speculative functionality or redesign settled decisions.

Validate the change and report any meaningful deviation from the spec.
