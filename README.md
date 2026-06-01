# qu1etboy skills

A personal library of AI agent skills following the [Agent Skills](https://agentskills.io) open standard. Skills are agent-agnostic and work across Claude Code, Cursor, Gemini CLI, and other compatible agents.

## Structure

```
skills/
├── engineer/
│   ├── architect/    # RFC, ADR, TRD — system design
│   ├── backend/      # Scalable backend engineering
│   ├── frontend/     # UI, accessibility, design systems
│   └── qa/           # Testing strategy, bug reports
└── product/          # Product management (coming soon)
```

## Installation

### Claude Code

Symlinks all skills into `~/.claude/skills/`:

```bash
make install
```

Restart Claude Code (or open a new session). Skills are picked up automatically and can be invoked directly:

```
/qa
/architect
/backend
/frontend
```

Or let Claude invoke them automatically when your message matches a skill's description.

### Claude.ai

Requires a Pro, Max, Team, or Enterprise plan with code execution enabled.

Package all skills as zip files:

```bash
make package
```

Then for each file in `dist/`:
1. Go to **Settings → Features → Skills**
2. Upload the zip

Skills are per-user and don't sync across team members — each person uploads separately.

### Other agents

Copy or symlink the individual skill directory (e.g. `engineer/qa/`) into your agent's skills folder. Refer to your agent's documentation for the exact path.
