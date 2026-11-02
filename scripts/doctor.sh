#!/bin/sh
# Read-only check for missing programs/assets used by this rice.
# Run it after ./scripts/install.sh.

miss=0
chk() {
    if command -v "$1" >/dev/null 2>&1; then
        printf 'ok       %s\n' "$1"
    else
        printf 'MISSING  %s\n' "$1"
        miss=$((miss + 1))
    fi
}

echo "===== core rice commands ====="
for c in Hyprland hyprctl waybar rofi kitty dunst wlogout \
         hypridle hyprlock hyprpaper hyprsunset hyprpicker hyprshot \
         hyprpolkitagent awww awww-daemon swww grim slurp wl-paste cliphist \
         jq mpv playerctl brightnessctl udiskie nautilus zeditor zed \
         woomer tplay cmatrix cbonsai nwg-look qt5ct qt6ct gsettings \
         fc-cache notify-send wpctl nmcli bluetoothctl; do
    chk "$c"
done

echo
echo "===== optional apps ====="
for c in spotify discord vesktop firefox btop yazi starship easyeffects; do
    chk "$c"
done

echo
echo "===== fonts / themes / icons ====="
if fc-list 2>/dev/null | grep -qi 'AdwaitaMono Nerd Font'; then
    echo "ok       font AdwaitaMono Nerd Font"
else
    echo "MISSING  font AdwaitaMono Nerd Font"
    miss=$((miss + 1))
fi

for d in \
    /usr/share/themes/hyprlain \
    /usr/share/icons/hyprlaicons \
    /usr/share/icons/AdwaitaLegacy \
    /usr/share/icons/rose-pine-hyprcursor \
    /usr/share/sddm/themes/Hyprlain
do
    if [ -d "$d" ]; then
        echo "ok       $d"
    else
        echo "MISSING  $d"
        miss=$((miss + 1))
    fi
done

echo
echo "===== existing config ====="
for f in \
    "$HOME/.config/hypr/hyprland.lua" \
    "$HOME/.config/hypr/programs.lua" \
    "$HOME/.config/hypr/input.lua" \
    "$HOME/.config/hypr/keys.lua" \
    "$HOME/.config/waybar/config.jsonc" \
    "$HOME/.config/rofi/config.rasi" \
    "$HOME/.config/assets/palette/palette.lua"
do
    if [ -e "$f" ]; then
        echo "ok       $f"
    else
        echo "MISSING  $f"
        miss=$((miss + 1))
    fi
done

echo
if [ -n "${HYPRLAND_INSTANCE_SIGNATURE:-}" ]; then
    echo "===== live Hyprland ====="
    if command -v jq >/dev/null 2>&1; then
        echo "-- monitors --"
        hyprctl monitors -j 2>/dev/null | jq -r '.[] | "\(.name)  \(.width)x\(.height)@\(.refreshRate)"'
        echo "-- keyboards --"
        hyprctl devices -j 2>/dev/null | jq -r '.keyboards[].name'
    else
        echo "install jq to list monitors/keyboards here"
    fi
    echo "-- config errors --"
    hyprctl configerrors 2>/dev/null
else
    echo "===== live Hyprland ====="
    echo "not running in this shell; after login run: hyprctl monitors && hyprctl configerrors"
fi

echo
echo "Missing count: $miss"
