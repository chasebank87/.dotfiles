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
    secretsConfig = import ./secrets.nix;
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

              xdg.enable = true;
              xdg.configHome = lib.mkForce "/Users/chase/.config";
            };
          };
        }
      ];
    };
  };
}
