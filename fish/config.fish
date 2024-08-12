if status is-interactive
fastfetch
end

set EDITOR "/usr/bin/nvim"

alias ls="exa --color=auto --hyperlink --icons=auto"
alias la="exa -a --color=auto --hyperlink --icons=auto"
alias lal="exa -la --color=auto --hyperlink --icons=auto"
alias şs="ls"

alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias undopush="git push -f origin HEAD^:master"
alias gs="git status"
alias gd="git diff"
alias ga="git add --all"
alias gac="git add --all; git commit -m"
alias gc="git commit -m"
alias gp="git push"
alias gl="git log"
alias gpu="git pull"
alias gr="git restore"

alias n="nvim"
alias cat="bat"
alias exe="chmod +x"
alias py="python"

# !! functionality for sudo
function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

# Set default apps
xdg-mime default org.gnome.Nautilus.desktop inode/directory
xdg-mime default floorp.desktop x-scheme-handler/https

# Set up zoxide as cd
zoxide init --cmd cd fish | source

# Set up fzf key bindings
fzf --fish | source

# Set up oh-my-posh
oh-my-posh init fish -c ~/.config/oh-my-posh/zen.toml | source

