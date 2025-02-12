# waybar-updates

[![ShellCheck](https://github.com/L11R/waybar-updates/actions/workflows/shellcheck.yml/badge.svg)](https://github.com/L11R/waybar-updates/actions/workflows/shellcheck.yml)

Tiny Waybar module to check Arch Linux updates from official repositories and AUR.

## Features
- Sends (optional) notifications about updates.
- Supports GNU gettext localization (contribute new po-files!)
- Support for [custom formats](#formatting) to show only the numbers you want.
- Checks updates from AUR using Aurweb RPC, so works independently.
- Can check for development packages upstream changes (see -d [options](#command-line-options))
- Shows updates in the tooltip.
- Supports two states: `pending-updates` and `updated` to use different icons or hide module.
- Uses infinite loop to supply Waybar JSON updates.
- Configurable interval between checks.

## Installation

1. Using AUR package `waybar-updates`.
2. Manually by using `make && make install`.

## Dependencies

- pacman-contrib
- gettext
- curl
- jq
- libnotify
- git (if using `--devel` [option](#command-line-options))

## Usage

`~/.config/waybar/config`:

```json
"modules-left": [
  ...
  "custom/pacman",
  ...
],

...

"custom/pacman": {
  "format": "{icon}{0}",
  "return-type": "json",
  "format-icons": {
    "pending-updates": " ",
    "updated": ""
  },
  "exec-if": "which waybar-updates",
  "exec": "waybar-updates"
}
```

`~/.config/waybar/style.css`

```css
@keyframes blink-update {
	to {
		background-color: dodgerblue;
	}
}

#custom-pacman {
	animation-timing-function: linear;
	animation-iteration-count: infinite;
	animation-direction: alternate;
}
#custom-pacman.pending-updates {
	animation-name: blink-update;
	animation-duration: 3s;
}
```

You can copy compiled mo-files and use `TEXTDOMAINDIR="$HOME/.config/waybar/scripts"` in case you want
to use localization and don't want to store them in `/usr/share/locale`.

### Command-line options
The following options are available:
| Option | Value | Default | Description |
|--------|-------|---------|-------------|
| `-f`, `--format` | `string` | `{total}` | Custom format used for main output text (see [Formatting](#formatting)) |
| `-t`, `--tooltip` | `string` |  | Custom tooltip format (see [Formatting](#formatting)) |
| `-i`, `--interval` | `int` | `6` | Interval (in seconds) between checks |
| `-c`, `--cycles` | `int` | `600` | Cycles between online checks (e.g. 6s *interval* * 600 *cycles* = 3600s = 1h) |
| `-l`, `--packages-limit` | `int` | `10` | Maximum number of packages to be shown in notifications and tooltip |
| `-d`, `--devel` | `none` | `off` | Also check for upstream changes in development packages |
| `-n`, `--notify` | `none` | `off` | Turns on notifications for updates |

#### Formatting

The tooltip and main text formatters can both use "labels" to format their output.

In `--tooltip`, the `{}` label will be replaced with the package list. In `--format`, it's an alias for `{total}`.

Supported custom count labels are `{aur}`, `{dev}`, `{pacman}` and `{total}`. These labels support a custom prefix and/or suffix which can be used to define icons, for example `{A :aur:\n}`, however keep in mind:
* Values **must** be separated with a colon (`:`)
* Values **may** contain newlines and tabs (`\n`, `\r` and `\t`)
* Values **cannot** contain braces (`{` or `}`), 


## Localization

Supported languages:

- English
- Russian
- French
- Turkish

1. Open `po/waybar-updates.pot` in poedit or any alternative.
2. Generate po-file for your language.
3. Translate!
4. Submit po-file by opening Pull Request!

---

Inspired by [waybar-module-pacman-updates](https://github.com/coffebar/waybar-module-pacman-updates).
