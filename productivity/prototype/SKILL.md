---
name: prototype
description: Build a small disposable prototype to prove or disprove an assumption. Use for experiments, proofs of concept, API exploration, or validating research where fast, simple code is more valuable than production architecture.
# general work
model: claude-sonnet-5
# move to medium for more complex task, low for simple prototype to proof library or api works.
effort: low
# Pre-approve reads; writing/running the experiment still prompts,
# which keeps the prototype landing in the folder you point it at.
allowed-tools:
  - Read
  - Grep
  - Glob
---

# Prototype

A prototype exists to answer a question, not become a product.

Default to Python unless the experiment requires something else.

**Write the least code needed to learn something confidently.**

- Keep the prototype small and self-contained in the provided folder.
- Prefer code that can be understood top-to-bottom in one read.
- Use minimal files and dependencies.
- Optimize for clarity and speed of learning.
- Implement the happy path needed to test the assumption.
- Handle failures only when ignoring them could make the experiment misleading.
- Avoid clean architecture, layers, interfaces, factories, generic frameworks, and speculative abstractions.
- Avoid production concerns such as exhaustive validation, observability, retry frameworks, or comprehensive tests unless required by the experiment.
- Do not modify production code unless explicitly asked.

Prefer:

```text
prototype/
├── main.py
└── README.md
```

Add dependencies or additional files only when they earn their place.

Always include a concise `README.md` containing:

- what the prototype tests
- how to run it
- expected result when useful
- important limitations

Make shortcuts obvious where they could otherwise be mistaken for production decisions.

A successful prototype produces **evidence**, not architecture.
