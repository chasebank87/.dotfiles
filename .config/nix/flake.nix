{
  description = "Chasebank87 nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/8809585e6937d0b07fc066792c8c9abf9c3fe5c4";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
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
    pkgs = nixpkgs.legacyPackages.${system};
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
                  ".config/nushell".source = "${dotfiles}/.config/nushell";
                  "Library/Application Support/nushell/config.nu".source = "${dotfiles}/.config/zoxide/pointer/config.nu";
                  "Library/Application Support/nushell/env.nu".source = "${dotfiles}/.config/zoxide/pointer/env.nu";
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
