#!/bin/bash
cd ~/Music/
[[ "`mpc | wc -l`" == "3" ]] && MPD=`mpc | head -n1 | cut -c 1-30` && timeout 0.45 feh --title Preview --scale-down -s ${MPD%.*}.jpg -g 768x432