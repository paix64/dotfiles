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

set EDITOR "/usr/bin/micro"

alias ls="exa --color=auto --hyperlink --icons=auto"
alias la="exa -a --color=auto --hyperlink --icons=auto"
alias lal="exa -la --color=auto --hyperlink --icons=auto"

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

alias m="micro"
alias cat="bat"
alias exe="chmod +x"

# !! functionality for sudo
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

# Set up zoxide as cd
zoxide init --cmd cd fish | source

# Set up fzf key bindings
fzf --fish | source

# Set the fuck up
thefuck --alias | source  

# Set up oh-my-posh
oh-my-posh init fish -c ~/.config/oh-my-posh/zen.toml | source

