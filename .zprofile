# fix a java swing problem
export _JAVA_AWT_WM_NONREPARENTING=1.

source /etc/profile # for guix
export GUILE_LOAD_PATH="$HOME/work/guix/"
# export QT_SCALE_FACTOR=2

# for pipx packages and scripts etc
export PATH="$HOME/.local/bin/:$PATH"

# some env vars
# source ~/work/arch/env.sh

# some env vars
# [ -f ~/brain/moredots/env.sh ] && source ~/brain/moredots/env.sh

# export HYPRLAND_INSTANCE_SIGNATURE=$(hyprctl instances | head -1 | cut -d ' ' -f2 | tr -d ':')