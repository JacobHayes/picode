# Claude Remote Control — Raspberry Pi

Persistent Claude Code remote-control sessions on a Raspberry Pi. Five sessions are always available at [claude.ai/code](https://claude.ai/code), surviving reboots via systemd.

## Quick Start

```bash
# Bootstrap from scratch
~/picode/.picode/picode setup
```

## Repository Structure

```
~/picode/
├── .picode/
│   ├── git/                    # bare git repo (used via GIT_DIR)
│   ├── picode                  # CLI script (symlinked to ~/.local/bin/picode)
│   ├── claude-rc.service       # systemd unit (symlinked to ~/.config/systemd/user/)
│   └── README.md               # this file
├── .gitignore                  # ignores everything except .picode/ and .gitignore
└── (agent working files...)    # untracked, gitignored
```

All infrastructure lives in `.picode/`. The `~/picode` directory itself is the clean working directory for agents — any files they create are gitignored.

## CLI Usage

```bash
picode start           # Start all 5 remote-control sessions in tmux
picode stop            # Stop all sessions
picode restart [N]     # Restart session N (1-5), or all if omitted
picode status          # Show tmux session status
picode attach          # Attach to the tmux session (Ctrl-b 0-4 to navigate)
picode git [args...]   # Run git with GIT_DIR/WORK_TREE set
picode setup           # Run first-time setup
```

## How It Works

- **tmux**: 5 windows (`s1`–`s5`) in session `claude-rc`, each running `claude remote-control --allow-dangerously-skip-permissions`
- **systemd user service**: starts tmux on boot; **loginctl linger** keeps it running without a login session
- **Retry loop + `remain-on-exit`**: sessions auto-restart on crash; tmux keeps dead windows visible for debugging
- **`echo y |`**: auto-accepts the remote control confirmation prompt

## Design Decisions

- **Everything in `.picode/`**: `~/picode` stays clean for agents to use as a working directory
- **Bare git repo**: avoids a `.git/` in the working dir; agent files gitignored by default, opt-in via negations
- **Single `picode` script**: self-contained CLI for setup, management, and git

## Git

The git repo is a bare repo at `.picode/git/`. Use the `picode git` wrapper:

```bash
picode git status
picode git log --oneline
picode git add -A && picode git commit -m "update"
```

## Accessing Sessions

- **Web**: [claude.ai/code](https://claude.ai/code)
- **Mobile**: Claude mobile app
- **QR code**: scan from claude.ai/code on another device
- **Local**: `picode attach` (then Ctrl-b + window number)
