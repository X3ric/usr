rm -rf $HOME/.cache/awesome/last-tag &>/dev/null
rm -rf $HOME/.cache/awesome/last-pos &>/dev/null
if [[ "$(tty)" = "/dev/tty1" ]]; then
	startx
fi
