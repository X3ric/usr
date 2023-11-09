# Runned on shell start
if [ -z "$NEOFETCH_RUNNED" ] && [ -n "$DISPLAY" ]; then
    NEOFETCH_RUNNED=1
    export NEOFETCH_RUNNED
    neofetch
fi
eval $(thefuck --alias)
HISTSIZE=10000
SAVEHIST=10000
ZDOTDIR=~/.config/zsh
ZCOMPDUMPDIR=~/.config/zsh/zcompdump
HISTFILE=~/.config/zsh/history
setopt appendhistory
setopt correct
setopt autocd
setopt cdablevars
setopt extended_glob
setopt dotglob
setopt glob_complete
autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots) ## Include hidden files.
#ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#ff00ff,bg=cyan,bold,underline"	# To get colored completion text
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(buffer-empty bracketed-paste accept-line push-line-or-edit)
ZSH_AUTOSUGGEST_STRATEGY=(history completion)
ZSH_AUTOSUGGEST_USE_ASYNC=true
bindkey '^ ' autosuggest-accept
bindkey -s '^B' "bookmarks\n"
bindkey -s '^T' "td\n"
bgnotify_threshold=4  ## set your own notification threshold
function notify_formatted {
  ## $1=exit_status, $2=command, $3=elapsed_time
  [ $1 -eq 0 ] && title="Task completed!"
  bgnotify "$title -- after $3 s" "$2";
}
[ -f "$HOME/.config/zsh/envrc" ] && source "$HOME/.config/zsh/envrc"
[ -f "$HOME/.config/zsh/aliasrc" ] && source "$HOME/.config/zsh/aliasrc"
[ -f "$HOME/.config/zsh/funcrc" ] && source "$HOME/.config/zsh/funcrc"
source /$HOME/.config/zsh/Internal/p10k.zsh
source /$HOME/.config/zsh/Internal/async.plugin.zsh
source /$HOME/.config/zsh/Internal/fzf-tab.plugin.zsh
source /$HOME/.config/zsh/Internal/fzf-key-bindings.plugins.zsh
source /$HOME/.config/zsh/Internal/fzf-completion.plugin.zsh
source /$HOME/.config/zsh/Internal/colored-man-pages.plugin.zsh
source /$HOME/.config/zsh/Internal/timer.plugin.zsh
source /$HOME/.config/zsh/Internal/forgit.plugin.zsh
source /$HOME/.config/zsh/Internal/bgnotify.plugin.zsh
source /$HOME/.config/zsh/Internal/zsh-autoquoter.zsh
source /$HOME/.config/zsh/Internal/nice-exit-code.plugin.zsh
source /$HOME/.config/broot/launcher/bash/br
source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh 2>/dev/null
source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh 2>/dev/null
source /usr/share/autojump/autojump.zsh 2>/dev/null
source /usr/share/zsh-theme-powerlevel10k/powerlevel10k.zsh-theme
# Zsh handlers
command_not_found_handler() {
  nyack "$1" || return 1
}
# Autocomplete
_cheat() { # cheat.sh command/bin autocomplete "tab"
    _arguments "1: :($(for dir in $(echo "$PATH" | tr ':' ' '); do \ls $dir; done))"
}
compdef _cheat cheat
_conf() { # conf autocomplete in .config dir
    local curcontext="$curcontext" state line
    _path_files -/ -W "$HOME/.config/" && return
    return 1
}
compdef _conf conf
_pacman-log() { # Autocompletion for pacman-log command
  local -a options
  options=(
    '-h'
    '-m'
    '-i'
    '-r'
    '-ri'
    '-rm'
    '-mi'
    '-rim'
  )
  _arguments -C \
    '1: :->cmd' \
    '2: :->files'
  case $state in
    (cmd)
      _describe "command" options
      ;;
    (files)
      _files
      ;;
  esac
}
compdef _pacman-log pacman-log
_pacman-list() { # Autocompletion for pacman-list command
  local -a options
  options=(
    '-h'
    '-a'
    '-p'
    '-ap'
  )
  _arguments -C \
    '1: :->cmd' \
    '2: :->files'
  case $state in
    (cmd)
      _describe "command" options
      ;;
    (files)
      _files
      ;;
  esac
}
compdef _pacman-list pacman-list
_isoburn() { # Autocompletion for isoburn functions
  _files -g "*.iso"
}
compdef _isoburn isoburn
_explain() { # Autocompletion for explain functions
    local all_commands=()
    if [[ -f "$HOME/.config/zsh/funcrc" ]]; then
        local funcrc_functions=$(grep -E '^\w+\(\)' "$HOME/.config/zsh/funcrc" | sed 's/().*$//')
        all_commands+=("${funcrc_functions[@]}")
    fi
    if [[ -f "$HOME/.config/zsh/aliasrc" ]]; then
        local aliasrc_aliases=$(sed -n '5,13d; s/^  alias -\?g* \?\([^=]*\)=.*/\1/p' "$HOME/.config/zsh/aliasrc")
        all_commands+=("${aliasrc_aliases[@]}")
    fi
    if [[ -d "$HOME/.local/share/bin" ]]; then
        all_commands+=($(find "$HOME/.local/share/bin" -maxdepth 1 -type f -exec basename {} \;))
    fi
    all_commands=($(echo "${all_commands[@]}" | sort -u))
    _arguments "1: :(${all_commands[*]})"
}
compdef _explain explain
