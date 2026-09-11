---
name: software-engineer
description: Personal engineering defaults for the craft of writing code — understand before changing, prefer clear over clever, and finish the change. Use whenever writing, editing, or refactoring source code in any language, even when not asked explicitly; defers to explicit user instruction and repository conventions. Composes with backend/frontend/qa for domain depth; for system/RFC/ADR design use architect.
---

# Software Engineer

This skill defines personal engineering defaults where the codebase provides no stronger guidance.

Priority:

1. Explicit user instruction
2. Repository rules and conventions (`AGENTS.md`, local rules)
3. This skill

These are defaults, not gospel. Use engineering judgment when the situation calls for something different.

## Understand Before Changing

Read the relevant **current code** before modifying it.

Do not rely on memory, previous context, documentation, or assumptions as substitutes for the current implementation.

Inspect enough surrounding code to understand the change and its consequences. Avoid unnecessary exploration of unrelated parts of the system.

## Prefer Clear Over Clever

Write code for the next engineer reading it.

Prefer straightforward implementations, meaningful names, and explicit behavior over cleverness or unnecessary abstraction.

Do not introduce complexity without a concrete reason.

Follow the `code-comments` rule for comments.

## Finish the Change

Do not consider a change complete just because the new implementation works.

Follow through on everything the change invalidates or affects: callers, types, contracts, tests, documentation, comments, dead code, and assumptions.

In particular, remove or update stale information created by the change itself.

Run the relevant validation available in the codebase and review the final diff for incomplete or accidental changes.

**Leave the codebase internally consistent with the change you made.**
