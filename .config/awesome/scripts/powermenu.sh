#!/bin/bash
UPTIME=$(uptime | awk '{ print $3 }')
MESSAGE="${UPTIME%,*}m > What do you want ${USER^}?"
POWER=""
RESTART=""
LOGOUT=""
#RES=`echo "$POWER|$RESTART|$LOGOUT" | rofi -dmenu -p "${MESSAGE%.*}" -sep "|" -theme powermenu -monitor -1`
RES=`echo "$POWER|$LOGOUT" | rofi -dmenu -p "${MESSAGE%.*}" -sep "|" -theme powermenu -monitor -1`
[ "$RES" = "$POWER" ] && systemctl poweroff
#[ "$RES" = "$RESTART"] && systemctl reboot
[ "$RES" = "$LOGOUT" ] && awesome-client 'awesome.quit()'