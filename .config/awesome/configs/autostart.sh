#!/bin/bash

function run {
  if ! pgrep $1 ;
  then
    $@&
  fi
}
#run lxpolkit
run /usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1
run xrandr --auto
run mpd --systemd
run mpd-mpris
run xfce4-clipman
run nm-applet
run blueman-applet
run uget-integrator
#run pulseaudio
#run ds4drv
#run sudo x11vnc -auth guess -forever -loop -noxdamage -repeat -rfbauth ~/.vnc/passwd -rfbport 5900 -shared -gui tray
#feh --bg-fill "$WP" 2> /dev/null
#you can set wallpapers in themes as well
feh --bg-fill ~/.config/awesome/wallpaper.png & 
run conky -c $HOME/.config/awesome/configs/conky.conf
#run dbus-daemon --session --address=systemd: --nofork --nopidfile --systemd-activation --syslog-only
#run insync start
#run ckb-next -b
#change shell 
#chsh -s /bin/zsh