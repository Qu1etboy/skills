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

Run the install script to symlink all skills into `~/.claude/skills/`:

```bash
./install.sh
```

Then restart Claude Code (or open a new session). Skills are picked up automatically.

Once installed, you can invoke any skill directly:

```
/qa
/architect
/backend
/frontend
```

Or let Claude invoke them automatically when your message matches a skill's description.

### Other agents

Copy or symlink the individual skill directory (e.g. `engineer/qa/`) into your agent's skills folder. Refer to your agent's documentation for the exact path.
