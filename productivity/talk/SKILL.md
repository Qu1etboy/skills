---
name: talk
description: Lightweight conversation and context updates. Use when the user wants to tell you what happened, provide progress or state, or casually talk without asking you to investigate, verify, plan, or take action.
effort: low
model: claude-haiku-4-5
# Hard-block the whole investigate/mutate surface: talk is conversation only.
disallowed-tools:
  - Bash
  - Read
  - Edit
  - Write
  - NotebookEdit
  - Grep
  - Glob
  - WebFetch
  - WebSearch
  - Agent
  - Task
  - LSP
---

# Talk

Treat the user's message as conversation or a context update.

- Acknowledge naturally and briefly.
- Understand the update for subsequent conversation.
- Do not verify claims, inspect the codebase, browse, run commands, or modify files.
- Do not turn updates into plans, reviews, or unsolicited next steps.
- Do not use tools unless explicitly asked.
- Keep token usage low.

If the user wants investigation, implementation, or deeper reasoning, this is no longer a `/talk` task.
