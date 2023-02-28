#!/bin/bash
$(dirname $0)/iconmusic.sh
NEXT=""
PLAY="喇"
PAUSE=""
PREV="丹"
PLAYER=""
[[ "`mpc | wc -l`" == "3" ]] && MPD=`mpc | head -n1 | cut -c 1-30` || MPD=`echo "No Music Playing"`
ICON=`[ "$(mpc | grep playing)" = "" ] && echo $PLAY || echo $PAUSE` 
RES=`echo "$PLAYER|$PREV|$ICON|$NEXT" | rofi -dmenu -p "${MPD%.*}" -sep "|" -theme music -monitor -1` 
[ "$RES" = "$PLAY" ] && mpc play && $(dirname $0)/iconmusic.sh
[ "$RES" = "$PAUSE" ] && mpc pause-if-playing
[ "$RES" = "$PREV" ] && mpc prev && $(dirname $0)/iconmusic.sh
[ "$RES" = "$NEXT" ] && mpc next && $(dirname $0)/iconmusic.sh
[ "$RES" = "$PLAYER" ] && kitty ncmpcpp 