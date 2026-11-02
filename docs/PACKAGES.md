# Packages

The PC's 94 explicit Arch packages are in
[`../packages/arch-explicit.txt`](../packages/arch-explicit.txt). Packages that
were AUR-only on Arch are in [`../packages/arch-aur.txt`](../packages/arch-aur.txt).
Do not install either list blindly on another distro.

Run [`../scripts/doctor.sh`](../scripts/doctor.sh) for the real gaps.

## Likely gaps and Gentoo names

Treat these as search hints, not guaranteed atoms. `emerge -s <name>` or check
the overlay that provides Hyprland (hyproverlay/GURU) first.

| Purpose | Gentoo (likely) | Notes |
|---|---|---|
| menu | `x11-misc/rofi` | the rice's menu/emoji config is rofi |
| logout menu | `gui-apps/wlogout` | AUR on Arch |
| wallpaper | `gui-apps/awww` | may not be in the tree; `swww` or `hyprpaper` fallback |
| screenshots | `gui-apps/hyprshot`, `gui-apps/grim`, `gui-apps/slurp` | |
| clipboard | `gui-apps/cliphist`, `gui-apps/wl-clipboard` | |
| idle/lock | `gui-apps/hypridle`, `gui-apps/hyprlock` | likely already in "Hypr tools" |
| night light | `gui-apps/hyprsunset` | optional |
| color picker | `gui-apps/hyprpicker` | |
| polkit | `gui-apps/hyprpolkitagent` | check whether it ships a systemd user unit |
| Qt theming | `x11-misc/qt5ct`, `x11-misc/qt6ct` | |
| GTK theme tool | `x11-misc/nwg-look` | |
| GTK theme base | `x11-themes/adw-gtk3` | optional; the rice has its own `hyprlain` theme |
| cursor | `x11-themes/rose-pine-hyprcursor` | or use the copied theme |
| media keys | `media-sound/playerctl` | |
| video/audio helper | `media-video/mpv` | used by the beep script |
| brightness | `sys-power/brightnessctl` | |
| JSON parser | `app-misc/jq` | used by the `wired` script and doctor |
| automount | `sys-fs/udiskie` | optional |
| file manager | `gnome-base/nautilus` | or change to `thunar` / `kitty -e yazi` |
| editor | `app-editors/zed` | or change to `kitty -e nvim` |
| zoom | `x11-misc/woomer` | optional, AUR-only on Arch |
| audio effects | `media-sound/easyeffects` | waybar right-click |
| fonts | (included) | `system/usr/local/share/fonts/ttf/AdwaitaMonoNerd` |

Everything else in `packages/arch-explicit.txt` is either already present, a
system-level package (`linux`, `linux-firmware`, `grub`, `limine`, `mkinitcpio`,
`btrfs-progs`, `zram-generator`, `networkmanager`, `iwd`, `bluez`, `nvidia-open`,
`amd-ucode`), or irrelevant to the rice (`go`, `hivex`, `yay`).

## Arch AUR-only packages on the PC

Generated in `packages/arch-aur.txt`:

`albert`, `cbonsai`, `cmatrix-git`, `hyprshade`, `hyprsysteminfo`, `iwgtk`,
`neofetch`, `overskride`, `rose-pine-hyprcursor`, `spicetify-cli`, `spotify`,
`tplay-git`, `vesktop`, `waypaper`, `wlogout`, `woomer`, `yay`, `yay-debug`.

Some are in Gentoo's GURU/overlays; others need an ebuild, source build,
Flatpak, or an alternative. `yay` is an Arch AUR helper and has no purpose on
Gentoo; Portage replaces it.

## Spotify theming

`.config/spicetify` and the `Hyprlain` theme are included. It needs
`spicetify-cli` on the target machine, and Spotify must have been launched at
least once. The config points at `~/.config/spotify/prefs`, which is
machine-specific and was not copied.

## Before installing

```sh
./scripts/doctor.sh
```

Then install only what it flags. Do not reinstall Hyprland/Waybar/kitty/dunst
unless the versions are wrong.
