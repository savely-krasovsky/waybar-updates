# waybar-updates

Tiny Waybar module to check Arch Linux updates from official repositories and AUR.

## Features
- Sends notifications about updates.
- Supports GNU gettext localization (contribute new po-files!)
- Checks updates from AUR using Aurweb RPC, so works independently.
- Shows updates in the tooltip.
- Supports two states: `pending-updates` and `updated` to use different icons or hide module.
- Uses infinite loop to supply Waybar JSON updates.
- Updates status every 6 seconds without using network.

## Installation

1. Using AUR package `waybar-updates`.
2. Manually by using `make && make install`.

## Dependencies

- pacman-contrib
- gettext
- curl
- jq
- libnotify

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
  "format": "{icon}{}",
  "return-type": "json",
  "format-icons": {
    "pending-updates": " ",
    "updated": ""
  },
  "exec-if": "which waybar-updates"
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

## Localization

Supported languages:

- English
- Russian

1. Open `po/waybar-updates.pot` in poedit or any alternative.
2. Generate po-file for your language.
3. Translate!
4. Submit po-file by opening Pull Request!

---

Inspired by [waybar-module-pacman-updates](https://github.com/coffebar/waybar-module-pacman-updates).