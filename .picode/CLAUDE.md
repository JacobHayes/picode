# picode

Persistent Claude remote-control sessions on a Raspberry Pi. The working directory is `~/picode`. This file and all infrastructure live in `~/picode/.picode/`.

## Git

The git repo is a bare repo at `~/picode/.picode/git/`. **Never use `git` directly.** Use:

```bash
picode git status
picode git add -A && picode git commit -m "message"
picode git log --oneline
```

## Project structure

- `~/picode/.picode/` — infrastructure (CLI, systemd service, docs). Tracked in git.
- `~/picode/*` — agent working files. **Gitignored by default.**
- To track a new file, add a negation to `~/picode/.gitignore` (e.g. `!myfile.txt`).

## Session management

```bash
picode status          # list sessions
picode restart [N]     # restart session N (1-5) or all
picode attach          # attach to tmux (Ctrl-b 0-4 to switch)
```

## Tools

- `picode` is the single entrypoint for all operations (sessions, git, setup)
- `gh` is available for GitHub operations (issues, PRs, API calls)
