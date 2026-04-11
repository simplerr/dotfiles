export PATH=$PATH:~/bin/

eval "$(fzf --bash)"

###
### My configs
###
alias g=git
alias eb='nvim ~/.bashrc.user'
alias sb='source ~/.bashrc.user'
alias st='tmux source-file ~/.tmux.conf'
alias et='nvim ~/.tmux.conf'
alias en='nvim ~/.config/nvim/'

export EDITOR=vim


if [ -t 1 ]; then
    red=$(tput setaf 1)
    green=$(tput setaf 2)
    yellow=$(tput setaf 3)
    purple=$(tput setaf 5)
    white=$(tput setaf 7)
    reset=$(tput sgr0)
    export MYPS1="\[$red\]\h\[$purple\]|\[$yellow\]"
    export MYPS2="\[$purple\]|\[$green\]\w\[$purple\]>\[$reset\]"
    export PS1="$MYPS1$EUFORI_NAME$MYPS2"
    bind '"\e[24~":"stty sane\n\n"'

    bind 'set page-completions off'
    bind 'set show-all-if-ambiguous on'
    bind 'set completion-query-items 9001'

    bind '"\e[A": history-search-backward'
    bind '"\e[B": history-search-forward'
    shopt -s checkwinsize
fi

alias icat='wezterm imgcat'

# Command history testing
# append rather than overwrite
  shopt -s histappend
  # attempts to save all lines of a multiple-line command in the same history entry
  shopt -s cmdhist
  # with cmdhist, saved with embedded newlines rather than semicolon separators
  shopt -s lithist

  HISTCONTROL=ignoreboth
  HISTSIZE=10000
  HISTFILESIZE=20000
  HISTTIMEFORMAT="%y/%m/%d %T "
  HISTIGNORE="history:ls:l:pwd:exit:"
  if [[ ${BASH_VERSION:0:1} -gt 5 || ${BASH_VERSION:0:1} -ge 5 && ${BASH_VERSION:2:1} -ge 1 ]]; then
    PROMPT_COMMAND=("history -a" "history -c" "history -r")
  else
    PROMPT_COMMAND="history -a; history -c; history -r"
  fi

# Clever absotule path command
abscmd() {
  local args=()
  for arg in "$@"; do
    if [ -e "$arg" ]; then
      args+=("$(realpath "$arg")")
    else
      args+=("$arg")
    fi
  done
  local result="${args[*]}"
  echo "$result"
  echo -ne "\033]52;c;$(echo -n "$result" | base64)\a"
}

# Pick argument(s) from the last command using fzf (Ctrl+x Ctrl+a)
# Use Tab to multi-select. Selection is inserted at cursor and copied to clipboard.
_fzf_pick_arg() {
    local selected
    selected=$(fc -ln -1 -1 | xargs -n1 | fzf --height=40% --reverse --multi | paste -sd ' ')
    if [ -n "$selected" ]; then
        READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${selected}${READLINE_LINE:$READLINE_POINT}"
        READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
        echo -ne "\033]52;c;$(echo -n "$selected" | base64)\a"
    fi
}
bind -x '"\C-x\C-a": _fzf_pick_arg'

# Pick a command from history, then pick argument(s) from it (Ctrl+x Ctrl+r)
_fzf_history_pick_arg() {
    local cmd selected
    cmd=$(history | sed 's/^ *[0-9]* *[0-9/]* [0-9:]* *//' | fzf --height=40% --reverse --tac --no-sort)
    if [ -n "$cmd" ]; then
        selected=$(echo "$cmd" | xargs -n1 | fzf --height=40% --reverse --multi | paste -sd ' ')
        if [ -n "$selected" ]; then
            READLINE_LINE="${READLINE_LINE:0:$READLINE_POINT}${selected}${READLINE_LINE:$READLINE_POINT}"
            READLINE_POINT=$(( READLINE_POINT + ${#selected} ))
            echo -ne "\033]52;c;$(echo -n "$selected" | base64)\a"
        fi
    fi
}
bind -x '"\C-x\C-r": _fzf_history_pick_arg'
