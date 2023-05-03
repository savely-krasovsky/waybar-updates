# Waybar module to check Arch updates

## Features
- Sends notifications about updates.
- Supports GNU gettext localization (contribute new po-files!)
- Shows updates in the tooltip.
- Checks updates from AUR using `yay`.
- Supports two states: `pending-updates` and `updated` to use different icons or hide module.
- Uses infinite loop to supply Waybar JSON updates.
- Updates status every 6 seconds without using network.

## Installation

1. ~~Using AUR~~ WIP
2. Manually by just copying script.

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
  "exec": "TEXTDOMAINDIR=\"$HOME/.config/waybar/scripts\" $HOME/.config/waybar/scripts/checkupdates.sh 2> /dev/null"
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

---

Inspired by [waybar-module-pacman-updates](https://github.com/coffebar/waybar-module-pacman-updates).