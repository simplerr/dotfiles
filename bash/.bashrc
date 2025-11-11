
eval "$(fzf --bash)"


###
### My configs
###
alias g=git
alias eb='nvim ~/.bashrc.user'
alias sb='source ~/.bashrc.user'
alias st='tmux source-file ~/.tmux.conf'
alias et='nvim ~/.tmux.conf'

export EDITOR=nvim

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

echo "Loaded .bashrc"

