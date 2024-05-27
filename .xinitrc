if test -z "$DBUS_SESSION_BUS_ADDRESS" ; then
    eval `dbus-launch --sh-syntax`
fi

# xwinwrap -ni -b -fs -ov -nf -- mplayer -cache 4096 -quiet -loop 0 -wid WID ~/ORBIT\ -\ A\ Journey\ Around\ Earth\ in\ Real\ Time\ \[\ 4k\ \]-Xjs6fnpPWy4.webm -nosound &

# parcellite unbinds C-M-x from emacs :(
#parcellite &

hsetroot -solid '#222222'
unclutter -root &
#blueman-applet &
mpris-proxy &
#syndaemon -K -i 0.5 -R -d &

xrdb -load ~/.Xresources &

# disable beep sound
sudo rmmod pcspkr &

# touchegg & # run touchegg for touch gestures

exec awesome