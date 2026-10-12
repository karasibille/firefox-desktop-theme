#!/usr/bin/env bash
#
# Declare the native messaging host to Firefox, pointing to host/ in this
# repository. Safe to run again.
set -euo pipefail

NAME=firefox_desktop_theme
HOST="$(cd "$(dirname "$0")" && pwd)/host/firefox-desktop-theme-host"

# Legacy profile directory, then the XDG one of recent Firefox versions
dirs=("$HOME/.mozilla/native-messaging-hosts")
if [ -d "${XDG_CONFIG_HOME:-$HOME/.config}/mozilla" ]; then
    dirs+=("${XDG_CONFIG_HOME:-$HOME/.config}/mozilla/native-messaging-hosts")
fi

for dir in "${dirs[@]}"; do
    mkdir -p "$dir"
    cat > "$dir/$NAME.json" <<EOF
{
  "name": "$NAME",
  "description": "Sends the desktop color theme to Firefox",
  "path": "$HOST",
  "type": "stdio",
  "allowed_extensions": ["firefox-desktop-theme@karasibille"]
}
EOF
    echo "ok   $dir/$NAME.json"
done
