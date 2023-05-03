#!/bin/bash

function checkUpdates() {
  if [ "$1" == "online" ]; then
    pacman_updates=$(checkupdates)
    yay_updates=$(yay -Qu --aur)
  elif [ "$1" == "offline" ]; then
    pacman_updates=$(checkupdates --nosync)
    yay_updates=$(yay -Qu --aur)
  fi

  # need it to send notification only when needed
  updates_checksum=$(echo "$pacman_updates$yay_updates" | sha256sum)

  pacman_updates_count=$(echo "$pacman_updates" | grep -vc ^$)
  yay_updates_count=$(echo "$yay_updates" | grep -vc ^$)

  total_updates_count=$((pacman_updates_count + yay_updates_count))
}

function json() {
  jq --unbuffered --null-input --compact-output \
    --arg text "$1" \
    --arg alt "$2" \
    --arg tooltip "$3" \
    --arg class "$4" \
    '{"text": $text, "alt": $alt, "tooltip": $tooltip, "class": $class}'
}

# sync at the first start
checkUpdates online
updates_checksum=""
# count cycles to check updates using network sometime
cycle=0

# check updates every 6 seconds
while true; do
  previous_updates_checksum=$updates_checksum

  if [ "$cycle" -ge 60 ]; then
    checkUpdates online
    cycle=0
  else
    checkUpdates offline
    cycle=$((cycle+1))
  fi

  if [ "$previous_updates_checksum" == "$updates_checksum" ]; then
    sleep 6
    continue
  fi

  if [ "$pacman_updates_count" -gt 0 ]; then
    template=$(ngettext "checkupdates.sh" "%d update available from pacman" "%d updates available from pacman" "%d")
    notify-send -u normal -i software-update-available-symbolic "$(printf "$template" "$pacman_updates_count")" "$pacman_updates"
  fi

  if [ "$yay_updates_count" -gt 0 ]; then
    template=$(ngettext "checkupdates.sh" "%d update available from AUR" "%d updates available from AUR" "$yay_updates_count")
    notify-send -u normal -i software-update-available-symbolic "$(printf "$template" "$yay_updates_count")" "$yay_updates"
  fi

  if [ "$total_updates_count" -gt 0 ]; then
    json $total_updates_count "pending-updates" "$pacman_updates$yay_updates" "pending-updates"
  else
    json "" "updated" "$(gettext "checkupdates.sh" "System is up to date")" "updated"
  fi

  sleep 6
done
