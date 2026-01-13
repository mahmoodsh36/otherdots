#!/usr/bin/env sh

ln -sf "$WORK_DIR/otherdots/.gitconfig" "$HOME/"

for filename in .xinitrc .zshrc .zprofile .Xresources .tmux.conf .pythonrc; do
    ln -sf "$WORK_DIR/otherdots/$filename" "$HOME/"
done

mkdir "$HOME/.config/"
for filename in alacritty compton.conf mimeapps.list mpv vifm qutebrowser kitty\
                          rofi sxhkd sxiv user-dirs.dirs zathura nushell wezterm xournalpp imv\
                          hypr goose aichat opencode; do
    ln -sf "$WORK_DIR/otherdots/.config/$filename" "$HOME/.config/"
done

mkdir ~/.config/transmission-daemon
mkdir ~/.config/transmission
ln -sf "$WORK_DIR/otherdots/.config/transmission-daemon/settings.json" "$HOME/.config/transmission/"
ln -sf "$WORK_DIR/otherdots/.config/transmission-daemon/settings.json" "$HOME/.config/transmission-daemon/"

mkdir "$HOME/.config/guix/"
ln -sf "$WORK_DIR/otherdots/channels.scm" "$HOME/.config/guix/"
sudo ln -sf "$WORK_DIR/otherdots/config.scm" "/etc/config.scm"

mkdir ~/.ssh/
ln -sf "$WORK_DIR/otherdots/.ssh/authorized_keys" "$HOME/.ssh/"
ln -sf "$WORK_DIR/otherdots/.ssh/config" "$HOME/.ssh/"
