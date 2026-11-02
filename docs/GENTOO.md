# Gentoo notes

Tested target: `ben`, systemd, Intel iGPU (`VIDEO_CARDS=intel`), Hyprland 0.57
from `hyproverlay`, Lua config.

## 1. Install

```sh
git clone https://github.com/wesar14/wesar.git
cd wesar
./scripts/install.sh
sudo fc-cache -f
./scripts/doctor.sh
```

The installer backs up existing files to `~/rice-backup/<timestamp>/`.
If you use `doas` instead of `sudo`, run the home part with `--user` and copy
the system assets manually:

```sh
./scripts/install.sh --user
doas cp -a system/usr/. /usr/
doas fc-cache -f
```

## 2. Post-install edits

### Monitors

`~/.config/hypr/hyprland.lua` ships the desktop's HDMI/DP block. Replace it with:

```lua
hl.monitor({
    output   = "eDP-1",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})

-- fallback for an external monitor
hl.monitor({
    output   = "",
    mode     = "preferred",
    position = "auto",
    scale    = 1,
})
```

If `eDP-1` is wrong, check with `hyprctl monitors`.

### Keyboard layout switch

```sh
hyprctl devices -j | jq -r '.keyboards[].name'
```

Edit `~/.config/hypr/programs.lua`:

```lua
M.nextKbdLayout = "hyprctl switchxkblayout YOUR_KEYBOARD next"
```

The same value exists in `programs.conf` for the fallback config.

### Waybar temperature

```sh
for h in /sys/class/hwmon/hwmon*; do printf '%s: ' "$h"; cat "$h/name"; done
```

Update `"hwmon-path"` in `~/.config/waybar/config.jsonc`. On Intel, `coretemp`
is usually the CPU. `thermal-zone` may also need changing.

### Programs

`~/.config/hypr/programs.lua`:

- `M.menu` — install `x11-misc/rofi`, or change to `wofi`:
  ```lua
  M.menu = "wofi"
  M.activateMenu = "killall wofi || wofi --show drun"
  ```
- `M.files` — install `gnome-base/nautilus`, or use `"kitty -e yazi"`.
- `M.editor` — install Zed, or use `"kitty -e nvim"`.
- `M.zoom` — `woomer` is optional; remove the bind if you don't install it.
- `M.takeScreenshot` — create `~/Media/Screenshots` or use `~/Pictures/Screenshots`.

### polkit

`programs.lua` starts:

```lua
hl.exec_cmd("systemctl --user start hyprpolkitagent")
```

That works on systemd if the package ships a user unit. If it doesn't:

```lua
hl.exec_cmd("hyprpolkitagent")
```

### SDDM (only if you use it)

```sh
sudo cp system/etc/sddm.conf.example /etc/sddm.conf.d/10-hyprlain.conf
```

If you use greetd, GDM, or start Hyprland from a TTY, ignore this.

## 3. First login

From a TTY:

```sh
Hyprland
```

Then:

```sh
hyprctl configerrors
hyprctl monitors
```

## 4. Packages

See [`PACKAGES.md`](PACKAGES.md). The likely gaps are `rofi`, `awww`,
`hyprshot`, `cliphist`, `wl-clipboard`, `grim`, `slurp`, `wlogout`,
`hyprpolkitagent`, `qt5ct`/`qt6ct`, `nwg-look`, `jq`, `playerctl`,
`brightnessctl`, and `mpv`.

## 5. Notes

- **awww** is the wallpaper daemon. If Gentoo/GURU doesn't have it, build it or
  switch `~/.config/hypr/wallpaper.lua` to `swww`/`hyprpaper`.
- **Intel**: no NVIDIA config is active. Ensure `media-libs/mesa`,
  `media-libs/vulkan-loader`, and `sys-kernel/linux-firmware` are installed.
- **nwg-look**: don't click Apply. The upstream Hyprlain README warns it can
  delete `~/.config/assets`.
- **Oh My Zsh**: `.zshrc` expects `~/.oh-my-zsh`.
- The `wired` script is not bound by default; `tplay`, `cmatrix`, and `cbonsai`
  are only needed if you use it.

## 6. Rollback

```sh
cp -a ~/rice-backup/<timestamp>/. "$HOME"/
```

Then log out/in.
