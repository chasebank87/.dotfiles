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

              home.activation = {
                nvimSetup = lib.hm.dag.entryAfter ["writeBoundary"] ''
                  # Ensure the base nvim directory exists
                  $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.config/nvim
                  
                  # Copy init.lua
                  $DRY_RUN_CMD cp -f $VERBOSE_ARG "${dotfiles}/.config/nvim/init.lua" ~/.config/nvim/init.lua
                  
                  # Remove and recreate lua directory to avoid permission issues
                  $DRY_RUN_CMD rm -rf $VERBOSE_ARG ~/.config/nvim/lua
                  $DRY_RUN_CMD mkdir -p $VERBOSE_ARG ~/.config/nvim/lua
                  
                  # Recursively copy lua directory with proper permissions
                  $DRY_RUN_CMD cp -rf $VERBOSE_ARG "${dotfiles}/.config/nvim/lua/"* ~/.config/nvim/lua/
                  
                  # Ensure the copied files have correct permissions
                  $DRY_RUN_CMD chmod -R $VERBOSE_ARG u+rw ~/.config/nvim/lua
                  
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
