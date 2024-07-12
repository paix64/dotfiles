if status is-interactive
echo \
"     ██████╗  ██████╗  █████╗ ██╗
    ██╔═══██╗ ██╔══██╗██╔══██╗██║
    ██║██╗██║ ██████╔╝███████║██║
    ██║██║██║ ██╔═══╝ ██╔══██║██║
    ╚█║████╔╝ ██║     ██║  ██║██║
     ╚╝╚═══╝  ╚═╝     ╚═╝  ╚═╝╚═╝"
end

alias ls="ls --color=auto --hyperlink=auto"
alias la="ls -a --color=auto --hyperlink=auto"
alias lal="ls -la --color=auto --hyperlink=auto"

alias cd..="cd .."
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias undopush="git push -f origin HEAD^:master"
alias gs="git status"
alias gd="git diff"
alias ga="git add ."
alias gac="git add . && git commit -m"
alias gc="git commit -m"
alias gp="git push"
alias gl="git log"
alias gpu="git pull"
alias gr="git restore"

set EDITOR "usr/bin/micro"
alias m="micro"

alias cat="bat"

function sudo
    if test "$argv" = !!
        eval command sudo $history[1]
    else
        command sudo $argv
    end
end

# bun
set --export BUN_INSTALL "$HOME/.bun"
set --export PATH $BUN_INSTALL/bin $PATH

zoxide init --cmd cd fish | source
