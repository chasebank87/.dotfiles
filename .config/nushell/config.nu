# Nushell Config File
#
# version = "0.100.0"

# Environment variables and PATH modifications
$env.XDG_CONFIG_HOME = $"($env.HOME)/.config"
$env.STARSHIP_CONFIG = $"($env.HOME)/.config/starship/starship.toml"
$env.BAT_THEME = "Dracula"


$env.config = {

  # Disable banner
  show_banner: false,

}

# Starship
use ~/.cache/starship/init.nu

# Zoxide
source ~/.cache/zoxide/init.nu