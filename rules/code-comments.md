---
paths:
  - "**/*.{go,ts,tsx,js,jsx,mjs,cjs,py,java,kt,rb,rs,ex,exs,c,h,cc,cpp,cs,swift,php,scala,sh,sql}"
---

# Code Comments

Treat comments as maintenance liabilities. Every comment must earn its place.

## Core Rule

**Code explains what and how. Comments explain why.**

Prefer self-documenting code over explanatory comments. Do not add comments merely because they make the code easier to understand at first glance.

### Comment when it preserves information the code cannot express

Good reasons include:

- non-obvious **why**
- intentional trade-offs
- assumptions or external constraints
- important invariants
- counterintuitive behavior
- dangerous edge cases
- reasons apparently unnecessary code must exist
- actionable TODOs linked to a ticket/task

```go
// Use external_gte because retries may deliver the same version more than once.
```

```go
// Keep this copy. The upstream SDK reuses the buffer after the callback returns.
```

```go
// TODO(EXP-1421): Remove legacy mapping after all producers emit v2 IDs.
```

### Do not narrate the code

Avoid comments describing:

- what a function obviously does
- file/package structure
- where types or logic live
- current wiring/dependencies
- implementation steps visible from the code

```go
// dto.go contains request/response types and mappers.
```

```go
// NewTagDirectory returns a TagDirectory using cfg.BaseURL.
```

These duplicate the code and become stale during refactors.

If clearer naming, types, functions, or structure can replace a comment, improve the code instead.

### Keep comments durable

Ask:

> Would a normal refactor require updating this comment?

If yes, the comment is probably too coupled to the implementation.

Architecture and repository rules belong in their authoritative documentation (`AGENTS.md`, ADRs, etc.), not duplicated across source files.

Public/library API documentation may describe **observable contracts**, but should avoid implementation details.

### Keep comments concise

Explain only the missing context. Do not turn comments into essays.

When uncertain, prefer no comment.

**Code tells us what exists. Comments tell us why it must be that way.**
