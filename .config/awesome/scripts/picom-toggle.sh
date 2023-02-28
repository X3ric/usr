#!/bin/bash
if pgrep -x "picom" > /dev/null
then
	killall picom
else
	picom --experimental-backend -b --config  $HOME/.config/awesome/configs/picom.conf
fi
