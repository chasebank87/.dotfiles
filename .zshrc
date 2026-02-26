export XDG_CONFIG_HOME="$HOME/.config"

export PATH=/usr/local/anaconda3/bin:$PATH
export PATH=/opt/homebrew/anaconda3/bin:$PATH
export PATH=/Users/chase/.cargo/bin:$PATH
export PATH=/Applications/Parallels\ Desktop.app/Contents/MacOS:$PATH
export PATH=/Users/chase/depot_tools:$PATH
export PATH=~/.local/bin:$PATH

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

# Initialize MongoDB
if ! brew services list | grep -q "mongodb-community"; then
    brew services start mongodb-community
fi

export STARSHIP_CONFIG="$HOME/.config/starship/starship.toml"
eval "$(starship init zsh)"

# Added by LM Studio CLI (lms)
export PATH="$PATH:/Users/chase/.cache/lm-studio/bin"

# Bat theme
export BAT_THEME="Dracula"

# Zoxide (better cd)
eval "$(zoxide init zsh)"
ZVM_INIT_MODE=sourcing

# Functions

## nu ls
function dq() {
    cmd=$1
    query=$2

    if [ -z "$query" ]; then
        nu -c "$cmd"
    else
        nu -c "$cmd | $query"
    fi
}

# Aliases

## nu style ls
#alias ls='dq "ls -la"'

## zoxide
alias cd='z'

## bat
alias cat='bat'

## windsurf
alias ws='windsurf'

## Nix Flake Update
alias nfu='''
echo "🔄 Updating Nix flake..."
pushd ~/.dotfiles/.config/nix > /dev/null
nix flake update
echo "🔧 Rebuilding system..."
sudo -H darwin-rebuild switch --flake ~/.dotfiles/.config/nix#m4macbook
echo "📝 Sourcing updated zshrc..."
source ~/.zshrc
echo "💾 Committing nvim changes..."
cd ~/.dotfiles/.config/nvim
git add .
git commit -m "Nix Flake Update"
git push origin master
echo "💾 Committing dotfiles changes..."
cd ~/.dotfiles
git add .
git commit -m "Nix Flake Update"
git push origin main
popd > /dev/null
echo "✅ Nix flake update complete!"
'''

## Nix Flake Rebuild
alias nfr='''
echo "🔧 Rebuilding Nix system..."
pushd ~/.dotfiles/.config/nix > /dev/null
darwin-rebuild switch --flake ~/.dotfiles/.config/nix#m4macbook
echo "📝 Sourcing updated zshrc..."
source ~/.zshrc
popd > /dev/null
echo "✅ Nix rebuild complete!"
'''

## The Fuck
eval $(thefuck --alias)
eval $(thefuck --alias fk)

neofetch
