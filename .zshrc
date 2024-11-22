export XDG_CONFIG_HOME="$HOME/.config"

export PATH=/usr/local/anaconda3/bin:$PATH
export PATH=/opt/homebrew/anaconda3/bin:$PATH

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/opt/homebrew/anaconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/opt/homebrew/anaconda3/etc/profile.d/conda.sh" ]; then
        . "/opt/homebrew/anaconda3/etc/profile.d/conda.sh"
    else
        export PATH="/opt/homebrew/anaconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/chase/.cache/lm-studio/bin"

# Bat theme
export BAT_THEME="Dracula"

# Zoxide (better cd)
eval "$(zoxide init zsh)"
ZVM_INIT_MODE=sourcing

# Aliases

## nu ls
function ls() {
    query=$1
    if [ -z "$query" ]; then
        nu -c "ls -l"
    else
        nu -c "ls -l | $query"
    fi
}
#alias ls='nu -c "ls -l"'

## zoxide
alias cd='z'

## bat
alias cat='bat'

## Nix Flake Update
alias nfu='''
pushd ~/.dotfiles/.config/nix > /dev/null
nix flake update
darwin-rebuild switch --flake ~/.dotfiles/.config/nix#m4macbook
source ~/.zshrc
cd ~/.dotfiles
git add .
git commit -m "Nix Flake Update"
git push origin main
popd > /dev/null
'''

## Nix Flake Rebuild
alias nfr='''
pushd ~/.dotfiles/.config/nix > /dev/null
darwin-rebuild switch --flake ~/.dotfiles/.config/nix#m4macbook
source ~/.zshrc
popd > /dev/null
'''

## The Fuck
eval $(thefuck --alias)
eval $(thefuck --alias fk)

neofetch
