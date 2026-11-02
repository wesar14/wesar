# Install

```sh
git clone https://github.com/wesar14/wesar.git
cd wesar
./scripts/install.sh
./scripts/doctor.sh
```

`install.sh` copies existing files to `~/rice-backup/<timestamp>/` before
overwriting anything. It installs:

- `.config/*`, `.local/share/audacious/Skins`, and the home dotfiles into `$HOME`
- `system/usr/*` into `/usr` (GTK theme, icons, cursor, font, SDDM theme), using `sudo`

Use `./scripts/install.sh --user` if you only want the home dotfiles.

## Requirements

- Hyprland 0.57+ for the Lua config. Older versions will use
  `~/.config/hypr/hyprland.conf` instead.
- Waybar, kitty, dunst, rofi, wlogout.
- `rofi` is the menu in the config; replace it with `wofi` if you prefer.
- `awww` for animated wallpapers. `swww`/`hyprpaper` are fallbacks.
- The system assets from this repo, or the fonts/themes will fall back to
  Adwaita.

## After installing

Read the post-install section in [`README.md`](README.md), then:

```sh
hyprctl configerrors
hyprctl monitors
```

For Gentoo-specific notes (systemd, Intel, `eDP-1`, sensors), see
[`docs/GENTOO.md`](docs/GENTOO.md).

## Rollback

```sh
tar -C "$HOME" -xzf ~/rice-backup/<timestamp>.tar.gz
```

The installer copies directories rather than creating a tarball, so rollback is:

```sh
cp -a ~/rice-backup/<timestamp>/. "$HOME"/
```

Then log out and back in.
