#!/usr/bin/env sh

ln -sf "$HOME/work/otherdots/.gitconfig" "$HOME/"

for filename in .xinitrc .zshrc .zprofile .Xresources .vimrc .tmux.conf; do
	ln -sf "$HOME/work/otherdots/$filename" "$HOME/"
done

mkdir "$HOME/.config/"
for filename in alacritty compton.conf gtk-3.0 mimeapps.list mpv vifm qutebrowser kitty\
	rofi sxhkd sxiv user-dirs.dirs transmission-daemon zathura; do
	ln -sf "$HOME/work/otherdots/.config/$filename" "$HOME/.config/"
done

ln -sf "$HOME/work/otherdots/.config/transmission-daemon" "$HOME/.config/transmission"

mkdir "$HOME/.config/guix/"
ln -sf "$HOME/work/otherdots/channels.scm" "$HOME/.config/guix/"
sudo ln -sf "$HOME/work/otherdots/config.scm" "/etc/config.scm"

mkdir "$HOME/.config/nvim/"
ln -sf "$HOME/work/otherdots/.vimrc" "$HOME/.config/nvim/init.vim"