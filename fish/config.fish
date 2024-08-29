if status is-interactive
    fastfetch
end

set EDITOR /usr/bin/nvim

alias ls="exa --color=auto --hyperlink --icons=auto"
alias la="exa -a --color=auto --hyperlink --icons=auto"
alias lal="exa -la --color=auto --hyperlink --icons=auto"
alias şs="ls"
alias l="ls"

alias ::="cd -"
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
alias grep="rg"
alias exe="chmod +x"
alias py="python"

# Set default apps
xdg-mime default nemo.desktop inode/directory
xdg-mime default zen-browser.desktop x-scheme-handler/https
xdg-mime default org.gnome.gedit.desktop text/plain

# Set up zoxide as cd
zoxide init --cmd cd fish | source

# Set up fzf key bindings
fzf --fish | source

# Set up oh-my-posh
oh-my-posh init fish -c ~/.config/oh-my-posh/zen.toml | source
