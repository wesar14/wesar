#!/usr/bin/env bash
# Install these dotfiles into $HOME (and optionally the system assets).
#
#   ./scripts/install.sh          # home dotfiles + /usr assets (uses sudo)
#   ./scripts/install.sh --user   # home dotfiles only
#
# Existing files are copied to ~/rice-backup/<timestamp>/ first.

set -euo pipefail

ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_HOME="${HOME:?HOME is not set}"
MODE="all"

case "${1:-}" in
    --user) MODE="user" ;;
    --all|"") MODE="all" ;;
    -h|--help)
        sed -n '2,8p' "$0"
        exit 0
        ;;
    *)
        echo "Unknown option: $1" >&2
        echo "Use --user or --all." >&2
        exit 1
        ;;
esac

if [ "$(id -u)" -eq 0 ]; then
    echo "Run this as your normal user, not root." >&2
    exit 1
fi

BACKUP="$TARGET_HOME/rice-backup/$(date +%Y%m%d-%H%M%S)"
mkdir -p "$BACKUP"

paths=(
    ".config/hypr"
    ".config/assets"
    ".config/waybar"
    ".config/rofi"
    ".config/dunst"
    ".config/kitty"
    ".config/wlogout"
    ".config/gtk-3.0"
    ".config/gtk-4.0"
    ".config/qt5ct"
    ".config/qt6ct"
    ".config/nwg-look"
    ".config/autostart"
    ".config/spicetify"
    ".config/audacious"
    ".config/neofetch"
    ".config/mimeapps.list"
    ".config/xsettingsd.conf"
    ".config/user-dirs.dirs"
    ".config/user-dirs.locale"
    ".local/share/audacious/Skins"
    ".zshrc"
    ".bashrc"
    ".bash_profile"
    ".profile"
    ".gtkrc-2.0"
)

echo "Backing up existing files to:"
echo "  $BACKUP"
for p in "${paths[@]}"; do
    if [ -e "$TARGET_HOME/$p" ]; then
        mkdir -p "$BACKUP/$(dirname "$p")"
        cp -a "$TARGET_HOME/$p" "$BACKUP/$p"
    fi
done

echo "Installing home dotfiles..."
mkdir -p "$TARGET_HOME/.config" "$TARGET_HOME/.local"
cp -a "$ROOT/.config/." "$TARGET_HOME/.config/"
cp -a "$ROOT/.local/." "$TARGET_HOME/.local/"
for f in .zshrc .bashrc .bash_profile .profile .gtkrc-2.0; do
    if [ -e "$ROOT/$f" ]; then
        cp -a "$ROOT/$f" "$TARGET_HOME/$f"
    fi
done

# The configs were written for user "ben". Rewrite absolute paths when
# installed by anyone else.
if [ "$(id -un)" != "ben" ]; then
    echo "Rewriting /home/ben paths for user $(id -un)..."
    find "$TARGET_HOME/.config" -type f \
        \( -name '*.conf' -o -name '*.lua' -o -name '*.ini' -o -name 'config' \) -print0 |
    while IFS= read -r -d '' f; do
        sed -i "s|/home/ben|$TARGET_HOME|g" "$f"
    done
fi

if [ "$MODE" = "all" ]; then
    echo "Installing system assets (theme, icons, cursor, font, SDDM theme)..."
    if command -v sudo >/dev/null 2>&1; then
        sudo cp -a "$ROOT/system/usr/." /usr/
        if command -v fc-cache >/dev/null 2>&1; then
            sudo fc-cache -f
        fi
    else
        echo "sudo not found. Copy system/usr/. to / manually, then run fc-cache -f." >&2
        echo "Home dotfiles were still installed." >&2
    fi
fi

echo
echo "Done. Previous config backed up to:"
echo "  $BACKUP"
echo
echo "Next:"
echo "  1. ~/.config/hypr/hyprland.lua        -> set monitor to eDP-1"
echo "  2. ~/.config/hypr/programs.lua        -> keyboard name, menu, files, editor"
echo "  3. ~/.config/waybar/config.jsonc      -> temperature sensor"
echo "  4. ./scripts/doctor.sh                -> check for missing programs"
echo "  5. Log out/in, or start Hyprland."
