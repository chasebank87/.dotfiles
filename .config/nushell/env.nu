# Environment variables
#$env.PATH = "/usr/local/anaconda3/bin:/opt/homebrew/anaconda3/bin:/Users/chase/.cache/lm-studio/bin:/opt/homebrew/bin:$env.PATH"

# Starship
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

# Zoxide
zoxide init nushell | save -f ~/.cache/zoxide/init.nu
