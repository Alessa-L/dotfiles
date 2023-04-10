autoload -U colors && colors
PROMPT="%n@%m %{${fg_bold[red]}%}:: %{${fg[green]}%}%3~%(0?. . %{${fg[red]}%}%? )%{${fg[blue]}%}»%{${reset_color}%} "

autoload -U compinit
zstyle ':completion:*' menu select
zmodload zsh/complist
compinit
_comp_options+=(globdots)

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh

source "$ZDOTDIR/zsh-vim-mode.plugin.zsh"
MODE_CURSOR_VIINS="steady bar"

alias "journalctl-error"="sudo journalctl -q -x -p err"
alias "history"="history | less"
alias "ssh"="export TERM=xterm && ssh"
alias "vi"="nvim"
alias "ls"="ls -lA"
alias "dotfiles"="git --git-dir=$HOME/Linux/dotfiles/ --work-tree=$HOME"

source "/usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"

source "$ZDOTDIR/zsh-history-substring-search.zsh"
bindkey '^[[A' history-substring-search-up
bindkey '^[[B' history-substring-search-down
