{
  description = "Chasebank87 nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
      url = "github:LnL7/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    dotfiles = {
      url = "path:/Users/chase/.dotfiles";
      flake = false;
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew, home-manager, dotfiles }:
  let
    system = "aarch64-darwin";
    secretsConfig = import "${dotfiles}/.config/nix/secrets.nix";
    pkgs = import nixpkgs {
      inherit system;
      config = {
        allowUnfree = true;
        allowUnsupportedSystem = true;
      };
    };
  in
  {
    darwinConfigurations."m4macbook" = nix-darwin.lib.darwinSystem {
      inherit system;
      specialArgs = { inherit dotfiles self; };
      modules = [ 
        ./configuration.nix
        nix-homebrew.darwinModules.nix-homebrew
        home-manager.darwinModules.home-manager
        {
          nixpkgs.pkgs = pkgs;
          
          nix.package = pkgs.nix;
          nix.settings = {
            experimental-features = [ "nix-command" "flakes" ];
            warn-dirty = false;
            access-tokens = "github.com=${secretsConfig.github_token}";
          };
          nix.optimise.automatic = true;
          
          nix-homebrew = {
            enable = true;
            enableRosetta = true;
            user = "chase";
            
            # Brew packages
            brews = [
              "git"
              "make"
              "unzip"
              "gcc"
              "ripgrep"
              "node"
              "ntfy"
              "pandoc"
              "starship"
              "neofetch"
              "zoxide"
              "go"
              "rust"
              "zig"
              "lua"
              "thefuck"
              "bat"
              "nushell"  
              "wget"
              "pam-reattach"
              "glfw"
              "jc"
              "freetype"
              "powershell/tap/powershell"
              "openjdk"
              "deno"
              "bun"
              "mas"
              "neovim"
              "mongodb-community"
              "mongodb-database-tools"
              "mongosh"
              "ffmpeg"
              "docker-compose"
              "poppler"
              "redis"
            ];
            
            # Cask applications
            casks = [
              "anaconda"
              "arc"
              "audacity"
              "cheatsheet"
              "cursor"
              "google-chrome"
              "hammerspoon"
              "karabiner-elements"
              "lm-studio"
              "microsoft-teams"
              "obsidian"
              "pallotron-yubiswitch"
              "pika"
              "raycast"
              "setapp"
              "steam"
              "visual-studio-code"
              "omnissa-horizon-client"
              "warp"
              "yubico-yubikey-manager"
              "kitty"
              "sublime-text"
              "geekbench"
              "geekbench-ai"
              "basictex"
              "transmission"
              "ghostty"
              "surfshark"
              "cinebench"
              "superkey"
              "caffeine"
              "windsurf"
              "todoist"
              "loopback"
              "audio-hijack"
              "trae"
              "homebrew/cask/docker"
              "openvpn-connect"
              "moonlight"
              "citrix-workspace"
              "jiggler"
              "the-unarchiver"
              "sigmaos"
              "zen"
              "handbrake"
              "sony-ps-remote-play"
              "vlc"
              "jump-desktop-connect"
            ];
            
            # Mac App Store apps
            masApps = {
              "Xcode" = 497799835;
              "Folder Preview" = 6698876601;
            };
            
            # Additional taps
            taps = [
              "oven-sh/bun"
              "mongodb/brew"
            ];
            
            # Configuration options
            onActivation = {
              cleanup = "zap";
              autoUpdate = true;
              upgrade = true;
            };
          };
          
          users.users.chase = {
            name = "chase";
            home = "/Users/chase";
          };
          
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;
            backupFileExtension = "backup";
            users.chase = { config, lib, ... }: {
              home = {
                username = "chase";
                homeDirectory = lib.mkForce "/Users/chase";
                stateVersion = "23.11";
                
                file = {
                  ".zshrc".source = "${dotfiles}/.zshrc";
                  ".config/starship".source = "${dotfiles}/.config/starship";
                  ".config/neofetch".source = "${dotfiles}/.config/neofetch";
                  ".config/kitty".source = "${dotfiles}/.config/kitty";
                  ".config/ghostty".source = "${dotfiles}/.config/ghostty";
                  ".config/nushell".source = "${dotfiles}/.config/nushell";
                  ".config/nvim/init.lua".source = "${dotfiles}/.config/nvim/init.lua";
                  ".config/nvim/.stylua.toml".source = "${dotfiles}/.config/nvim/.stylua.toml";
                  ".config/nvim/lua".source = "${dotfiles}/.config/nvim/lua";
                  "Library/Application Support/nushell/config.nu".source = "${dotfiles}/.config/nushell/pointer/config.nu";
                  "Library/Application Support/nushell/env.nu".source = "${dotfiles}/.config/nushell/pointer/env.nu";
                };
              };

              programs = {
                home-manager.enable = true;
                git = {
                  enable = true;
                  userName = "chasebank87";
                  userEmail = "chase@chaseelder.com";
                };
              };

              # Use a minimal activation script just for lazy-lock.json
              home.activation = {
                nvimLazyLock = lib.hm.dag.entryAfter ["writeBoundary"] ''
                  # Ensure the base nvim directory exists
                  $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.config/nvim
                  
                  # Ensure we have a writable lazy-lock.json
                  $DRY_RUN_CMD touch $VERBOSE_ARG ~/.config/nvim/lazy-lock.json
                  $DRY_RUN_CMD chmod $VERBOSE_ARG 644 ~/.config/nvim/lazy-lock.json
                '';
              };

              xdg.enable = true;
              xdg.configHome = lib.mkForce "/Users/chase/.config";
            };
          };
        }
      ];
    };
  };
}
