#!/usr/bin/env sh

FILE="$HOME/.cache/eww_launch.dashboard"
CFG="$HOME/.config/eww/dashboard/"

# launch or close widgets accordingly
if [[ ! -f "$FILE" ]]; then
	touch "$FILE"
	eww --config "$CFG" open-many date reddit telegram youtube github system weather apps time spotify logout sleep reboot resources poweroff profile
else
	eww --config "$CFG" close     date github reddit youtube telegram system apps time weather spotify profile poweroff resources reboot sleep reboot logout
	rm "$FILE"
fi
