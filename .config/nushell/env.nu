# Environment variables
$env.PATH = ($env.PATH | split row (char esep) | append '/usr/local/anaconda3/bin')
$env.PATH = ($env.PATH | split row (char esep) | append '/opt/homebrew/anaconda3/bin')
$env.PATH = ($env.PATH | split row (char esep) | append '/Users/chase/.cache/lm-studio/bin')
$env.PATH = ($env.PATH | split row (char esep) | append '/opt/homebrew/bin')
$env.PATH = ($env.PATH | split row (char esep) | append '/usr/bin')

# Starship
mkdir ~/.cache/starship
starship init nu | save -f ~/.cache/starship/init.nu

# Zoxide
zoxide init nushell | save -f ~/.cache/zoxide/init.nu
