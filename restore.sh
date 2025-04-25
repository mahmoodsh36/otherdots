#!/usr/bin/env sh

ln -sf "$HOME/work/otherdots/.gitconfig" "$HOME/"

for filename in .xinitrc .zshrc .zprofile .Xresources .tmux.conf .pythonrc .lem; do
    ln -sf "$HOME/work/otherdots/$filename" "$HOME/"
done

mkdir "$HOME/.config/"
for filename in alacritty compton.conf mimeapps.list mpv vifm qutebrowser kitty\
                          rofi sxhkd sxiv user-dirs.dirs zathura nushell wezterm xournalpp imv\
                          hypr goose aichat; do
    ln -sf "$HOME/work/otherdots/.config/$filename" "$HOME/.config/"
done

mkdir ~/.config/transmission-daemon
mkdir ~/.config/transmission
ln -sf "$HOME/work/otherdots/.config/transmission-daemon/settings.json" "$HOME/.config/transmission/"
ln -sf "$HOME/work/otherdots/.config/transmission-daemon/settings.json" "$HOME/.config/transmission-daemon/"

mkdir "$HOME/.config/guix/"
ln -sf "$HOME/work/otherdots/channels.scm" "$HOME/.config/guix/"
sudo ln -sf "$HOME/work/otherdots/config.scm" "/etc/config.scm"

mkdir ~/.ssh/
ln -sf "$HOME/work/otherdots/.ssh/authorized_keys" "$HOME/.ssh/"
ln -sf "$HOME/work/otherdots/.ssh/config" "$HOME/.ssh/"