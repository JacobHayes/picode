#!/usr/bin/env bash
# Migrate from claude-rc naming to picode naming

set -euo pipefail

echo "Migrating from claude-rc to picode naming..."

# Stop and disable old service
if systemctl --user is-active claude-rc &>/dev/null; then
    echo "  Stopping claude-rc service..."
    systemctl --user stop claude-rc
fi

if systemctl --user is-enabled claude-rc &>/dev/null; then
    echo "  Disabling claude-rc service..."
    systemctl --user disable claude-rc
fi

# Remove old symlink
if [ -L "$HOME/.config/systemd/user/claude-rc.service" ]; then
    echo "  Removing old service symlink..."
    rm "$HOME/.config/systemd/user/claude-rc.service"
fi

# Kill old tmux session
if tmux has-session -t claude-rc 2>/dev/null; then
    echo "  Killing old tmux session..."
    tmux kill-session -t claude-rc
fi

# Reload systemd
systemctl --user daemon-reload

echo "  Done. Run 'picode setup' to install the new service."
