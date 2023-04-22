fish_add_path -gp $HOME/.local/bin

set -gx EDITOR /usr/bin/nvim

# Home cleanup
set -gx PYTHONSTARTUP $HOME/.config/python/pythonrc
set -gx LESSHISTFILE 
set -gx __GL_SHADER_DISK_CACHE_PATH $HOME/.config/nvidia
set -gx GNUPGHOME $HOME/.config/gnupg
set -gx CARGO_HOME $HOME/.config/cargo

if status is-interactive
    # Commands to run in interactive sessions can go here
    set fish_autosuggestion_enabled 0
    set fish_greeting

    fish_vi_key_bindings
    set fish_cursor_insert line
    set fish_cursor_replace line
    set fish_cursor_replace_one line

    alias "journalctl-error"="sudo journalctl -q -x -p err"
    alias "history"="history | less"
    alias "ssh"="export TERM=xterm && ssh"
    alias "vi"="nvim"
    alias "ls"="ls -lA --group-directories-first --color=always"
    alias "dotfiles"="git --git-dir=$HOME/Linux/dotfiles/ --work-tree=$HOME"
    alias "code"="code --extensions-dir=.config/Code/Extensions"
end
