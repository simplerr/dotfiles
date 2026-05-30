# zsh config (ported from bash/.bashrc)

export PATH="$HOME/.local/bin:$HOME/bin:$PATH"

# rustup (keg-only Homebrew install) -> puts rustc/cargo on PATH
[ -d "/opt/homebrew/opt/rustup/bin" ] && export PATH="/opt/homebrew/opt/rustup/bin:$PATH"

# fzf shell integration (key bindings + completion)
if command -v fzf >/dev/null 2>&1; then
  source <(fzf --zsh)
fi

###
### My configs
###
alias g=git
alias eb='nvim ~/.zshrc.user'
alias sb='source ~/.zshrc.user'
alias st='tmux source-file ~/.tmux.conf'
alias et='nvim ~/.tmux.conf'
alias en='nvim ~/.config/nvim/'
alias icat='wezterm imgcat'

export EDITOR=vim

# Prompt: host|EUFORI_NAME|cwd>  (red|magenta|yellow|magenta|green|magenta)
setopt PROMPT_SUBST
PROMPT='%F{red}%m%F{magenta}|%F{yellow}${EUFORI_NAME}%F{magenta}|%F{green}%~%F{magenta}>%f'

# Completion
autoload -Uz compinit && compinit
setopt AUTO_LIST          # list choices on ambiguous completion
unsetopt LIST_BEEP

# Prefix history search on Up/Down (like bash history-search-backward/forward)
autoload -Uz up-line-or-beginning-search down-line-or-beginning-search
zle -N up-line-or-beginning-search
zle -N down-line-or-beginning-search
bindkey '^[[A' up-line-or-beginning-search
bindkey '^[[B' down-line-or-beginning-search

# F12 -> reset terminal (stty sane)
_stty_sane() { stty sane; zle reset-prompt; }
zle -N _stty_sane
bindkey '^[[24~' _stty_sane

###
### History
###
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=20000
setopt EXTENDED_HISTORY       # timestamps (was HISTTIMEFORMAT)
setopt SHARE_HISTORY          # write/read across sessions (was PROMPT_COMMAND history -a/-c/-r)
setopt APPEND_HISTORY         # was histappend
setopt HIST_IGNORE_DUPS       # part of HISTCONTROL=ignoreboth (ignoredups)
setopt HIST_IGNORE_SPACE      # part of HISTCONTROL=ignoreboth (ignorespace)
setopt HIST_REDUCE_BLANKS

# Don't store these commands (was HISTIGNORE="history:ls:l:pwd:exit:")
zshaddhistory() {
  local line=${1%%$'\n'}
  case "$line" in
    history|ls|l|pwd|exit) return 1 ;;
  esac
  return 0
}

# Clever absolute path command
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
    selected=$(fc -ln -1 | xargs -n1 | fzf --height=40% --reverse --multi | paste -sd ' ')
    if [ -n "$selected" ]; then
        LBUFFER="${LBUFFER}${selected}"
        echo -ne "\033]52;c;$(echo -n "$selected" | base64)\a"
    fi
    zle reset-prompt
}
zle -N _fzf_pick_arg
bindkey '^X^A' _fzf_pick_arg

# Pick a command from history, then pick argument(s) from it (Ctrl+x Ctrl+r)
_fzf_history_pick_arg() {
    local cmd selected
    cmd=$(fc -rln 1 | fzf --height=40% --reverse --no-sort)
    if [ -n "$cmd" ]; then
        selected=$(echo "$cmd" | xargs -n1 | fzf --height=40% --reverse --multi | paste -sd ' ')
        if [ -n "$selected" ]; then
            LBUFFER="${LBUFFER}${selected}"
            echo -ne "\033]52;c;$(echo -n "$selected" | base64)\a"
        fi
    fi
    zle reset-prompt
}
zle -N _fzf_history_pick_arg
bindkey '^X^R' _fzf_history_pick_arg

# Per-machine / local overrides
[ -f ~/.zshrc.user ] && source ~/.zshrc.user
