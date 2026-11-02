<div align="center">
<img src="preview/logo.svg" alt="Hyprlain" width="420">
</div>

# Hyprlain Dotfiles

My Hyprland rice, based on [Hyprlain](https://github.com/Ascaniolamp/Hyprlain),
ported to Hyprland 0.57's Lua config.

Tested on:

- **Arch Linux** — desktop, NVIDIA, two monitors (1080p240 + rotated 1080p75)
- **Gentoo (systemd)** — laptop, Intel iGPU, single `eDP-1` panel

The configs are hardware-agnostic except for the monitor block, waybar's
temperature sensor, and the keyboard name used for layout switching. Those are
covered in the post-install section.

## What's included

| Path | Contents |
|---|---|
| `.config/hypr/` | Hyprland Lua config, fallback `.conf`, scripts, shaders, keymap |
| `.config/assets/` | wallpapers/GIFs, palette, audio |
| `.config/waybar/` | bar config, style, power menu |
| `.config/rofi/` | menu config and Hyprlain theme |
| `.config/{dunst,kitty,wlogout,gtk-3.0,gtk-4.0}` | desktop theming |
| `.config/{qt5ct,qt6ct,nwg-look}` | Qt/GTK theme settings |
| `.config/{spicetify,audacious}` | optional Spotify/Audacious themes |
| `system/usr/` | GTK theme, icons, hyprcursor, AdwaitaMono Nerd Font, SDDM theme |
| `scripts/install.sh` | installs dotfiles + system assets, backs up the old ones |
| `scripts/doctor.sh` | reports missing programs/assets |
| `packages/` | Arch package lists |
| `docs/` | Gentoo notes and package mapping |

## Install

Back up first — the installer does this automatically, but read the script.

```sh
git clone https://github.com/wesar14/wesar.git
cd wesar

# home dotfiles + /usr theme/icons/font/SDDM theme (uses sudo)
./scripts/install.sh

# or home dotfiles only
./scripts/install.sh --user
```

Then check what the distro is missing:

```sh
./scripts/doctor.sh
```

If you are on Gentoo, read [`docs/GENTOO.md`](docs/GENTOO.md). It has the exact
post-install edits for a laptop: `eDP-1`, Intel sensors, keyboard name, and
rofi/wofi.

## Post-install edits

Open these three files:

1. **Monitors** — `~/.config/hypr/hyprland.lua`

   The repo ships the desktop's monitor block. Replace it with your panel:

   ```lua
   hl.monitor({ output = "eDP-1", mode = "preferred", position = "auto", scale = 1 })
   hl.monitor({ output = "",      mode = "preferred", position = "auto", scale = 1 })
   ```

   Check the real name with `hyprctl monitors`.

2. **Keyboard / programs** — `~/.config/hypr/programs.lua`

   - `M.nextKbdLayout` targets `logitech-usb-receiver-keyboard`.
     Replace it with `hyprctl devices -j | jq -r '.keyboards[].name'`.
   - `M.menu` is `rofi`; install it or switch to `wofi`.
   - `M.files` is `nautilus`; change to `kitty -e yazi` or `thunar`.
   - `M.editor` is `zeditor`; change to `kitty -e nvim` if you don't use Zed.
   - `M.takeScreenshot` writes to `Media/Screenshots`; create that directory
     or change it to `Pictures/Screenshots`.

3. **Waybar temperature** — `~/.config/waybar/config.jsonc`

   The repo has `/sys/class/hwmon/hwmon2/temp1_input`. Find yours:

   ```sh
   for h in /sys/class/hwmon/hwmon*; do printf '%s: ' "$h"; cat "$h/name"; done
   ```

   Point `"hwmon-path"` at the CPU sensor, or remove the temperature module.

Then log out/in (or start Hyprland from a TTY) and run:

```sh
hyprctl configerrors
```

## Keybinds

| Keys | Action |
|---|---|
| `Super + Return` | kitty |
| `Super + W` | Firefox |
| `Super + E` | file manager |
| `Super + T` | editor |
| `Super + Space` | rofi menu |
| `Super + Q` | close window |
| `Super + F` | fullscreen |
| `Super + V` | toggle floating |
| `Super + 1..0` | workspaces |
| `Super + Shift + 1..0` | move window to workspace |
| `Super + S` | scratchpad |
| `Super + Shift + S` | screenshot |
| `Super + Shift + P` | color picker |
| `Super + O` | toggle waybar |
| `Super + H/J/K/L` | focus window |
| `Super + Shift + H/J/K/L` | move window |

The full list is in `.config/hypr/keys.lua`.

## Notes

- **Wallpaper daemon:** the config uses `awww` for animated GIFs. If your distro
  doesn't package it, build it or switch `wallpaper.lua` to `swww`/`hyprpaper`.
- **No NVIDIA config is active.** The desktop uses `nvidia-open`; the config
  itself has no NVIDIA environment variables set.
- **nwg-look warning:** the upstream Hyprlain README says clicking "Apply" in
  nwg-look can delete `~/.config/assets`. The GTK config is already applied;
  don't use nwg-look's Apply button unless you have backed up `assets/`.
- **Absolute paths:** the configs were written for user `ben`. The installer
  rewrites `/home/ben` to your `$HOME` when run by another user, but check
  `input.lua`, `qt5ct`, `qt6ct`, `spicetify`, and `audacious` if something is
  still pointing at `/home/ben`.
- **Oh My Zsh:** `.zshrc` expects `~/.oh-my-zsh`. Install it or remove the
  `source $ZSH/oh-my-zsh.sh` line.
- **Spicetify/Audacious** themes are optional and need their respective apps.
- A **Vesktop autostart** entry is included at `.config/autostart/vesktop.desktop`.
  Remove it if you don't use Vesktop.

## Credits and license

This is a modified version of [Hyprlain](https://github.com/Ascaniolamp/Hyprlain)
by Ascaniolamp, which is GPLv3. See [`CREDITS.md`](CREDITS.md) and
[`LICENSE`](LICENSE). Third-party wallpapers, fonts, icons, and themes may carry
their own licenses; check the upstream sources before redistributing them.
