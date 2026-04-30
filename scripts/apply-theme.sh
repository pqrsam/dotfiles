#!/usr/bin/env bash

set -e

CONFIG_FILE="$HOME/.config/workspace-1/theme.conf"

[ -f "$CONFIG_FILE" ] || { echo "Missing config: $CONFIG_FILE"; exit 1; }

source "$CONFIG_FILE"

[ -n "$MAIN_COLOR" ] || { echo "MAIN_COLOR not set"; exit 1; }
[ -n "$POWERLINE_COLOR" ] || { echo "POWERLINE_COLOR not set"; exit 1; }

KITTY_CONF="$HOME/.config/kitty/kitty.conf"
sed -i '/^color5 /d' "$KITTY_CONF"
sed -i '/^color13 /d' "$KITTY_CONF"
echo "color5 $MAIN_COLOR" >> "$KITTY_CONF"
echo "color13 $MAIN_COLOR" >> "$KITTY_CONF"

VIS_FILE="$HOME/.config/vis/colors/main"
echo "$MAIN_COLOR" > "$VIS_FILE"

VTOP_THEME="/usr/lib/node_modules/vtop/themes/becca.json"

command -v jq >/dev/null 2>&1 || { echo "jq required"; exit 1; }

tmp=$(mktemp)

jq --arg c "$MAIN_COLOR" '
  .title.fg = $c
  | .chart.fg = $c
  | .chart.border.fg = $c
  | .table.border.fg = $c
  | .table.items.selected.bg = $c
' "$VTOP_THEME" > "$tmp"

sudo mv "$tmp" "$VTOP_THEME"

I3_CONFIG="$HOME/.config/i3/config"

sed -i \
  -e "s|^\s*background .*|        background $I3_BAR_BACKGROUND|" \
  "$I3_CONFIG"

sed -i -E \
  "s|^\s*focused_workspace\s+#[0-9a-fA-F]{6}\s+#[0-9a-fA-F]{6}(\s+#[0-9a-fA-F]{6}\s+#[0-9a-fA-F]{6})|        focused_workspace  $I3_BAR_FOCUSED_WS\1|" \
  "$I3_CONFIG"

sed -i -E \
  "s|^\s*inactive_workspace\s+#[0-9a-fA-F]{6}\s+#[0-9a-fA-F]{6}(\s+#[0-9a-fA-F]{6}\s+#[0-9a-fA-F]{6})|        inactive_workspace $I3_BAR_INACTIVE_WS\1|" \
  "$I3_CONFIG"

POWERLINE_THEME="$HOME/.config/powerline-shell/theme.py"

if [ -f "$POWERLINE_THEME" ]; then
  sed -i \
    -e "s|^\s*HOME_BG\s*=.*|    HOME_BG = $POWERLINE_COLOR|" \
    "$POWERLINE_THEME"
fi

i3-msg reload >/dev/null 2>&1 || true

echo "Theme applied"