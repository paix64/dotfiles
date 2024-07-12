if status is-interactive
echo \
"
     ██████╗  ██████╗  █████╗ ██╗
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

set EDITOR "/usr/bin/micro"
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

# Set up fzf key bindings
fzf --fish | source

if test "~/.bun/bin/oh-my-posh"
    echo ""
else
    echo "Installing Oh My Posh"
    mkdir -p "~/.bun/bin"
    curl -s https://ohmyposh.dev/install.sh | bash -s -- -d ~/.bun/bin
    
end  

oh-my-posh init fish -c ~/.config/oh-my-posh/zen.toml | source
