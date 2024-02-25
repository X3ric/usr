rm -rf $HOME/.cache/awesome/last-tag &>/dev/null
rm -rf $HOME/.cache/awesome/last-pos &>/dev/null
if [[ $TTY == "/dev/tty1" ]]; then
	startx
else
	if [[ $TTY == "/dev/tty*" ]]; then
		export tty='true'
		if ! command -v scrollback &>/dev/null; then	
			[ ! -z "$HOME"/.local/share/bin/scrollback/ ] && cd "$HOME"/.local/share/bin/scrollback/ && make && sudo make install
		else
			! $SCROLLBACK false && scrollback -c /bin/zsh && exec scrollback /bin/zsh
		fi
	else
		export pts='true'
	fi
fi
