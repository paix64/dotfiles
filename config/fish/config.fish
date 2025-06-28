if status is-interactive
    fastfetch
    alias rm="gio trash"
end

set EDITOR micro

alias ls="exa --color=auto --hyperlink --icons=auto"
alias l="ls"
alias la="ls -a"
alias lal="ls -la"

alias cd..="cd .."
alias ::="cd -"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."

alias undopush="git push -f origin HEAD^:master"
alias gs="git status"
alias gd="git diff"
alias ga="git add --all"
alias gb="git branch"
alias gac="git add --all; git commit -m"
alias gc="git commit -m"
alias gp="git push"
alias gl="git log"
alias gpu="git pull"
alias gr="git restore"
alias gcl="git clone"
alias gch="git checkout"

alias yay="paru"
alias m="micro"
alias cat="bat"
alias grep="rg"
alias exe="chmod +x"
alias py="python"
alias dua="dua interactive"
alias quiet="asusctl profile -P LowPower"

function mkcd
  mkdir -p $argv[1] && cd $argv[1]
end

# Set up zoxide as cd
zoxide init --cmd cd fish | source

# Set up fzf key bindings
fzf --fish | source

# Set up starship
export STARSHIP_CONFIG=$HOME/.config/starship/starship.toml

function starship_transient_prompt_func
  starship module character
end

starship init fish | source
enable_transience

set fish_greeting ""

# Created by `pipx` on 2025-03-09 14:19:49
set PATH $PATH /home/pai/.local/bin
