{
  description = "Chasebank87 nix-darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/8809585e6937d0b07fc066792c8c9abf9c3fe5c4";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs, nix-homebrew }:
  let
    configuration = { pkgs, config, ... }: {

			nixpkgs.config.allowUnfree = true;
      # List packages installed in system profile. To search by name, run:
      # $ nix-env -qaP | grep wget
      environment.systemPackages = [ 
				pkgs.vim
				pkgs.mkalias
      ];

			fonts.packages = [
				(pkgs.nerdfonts.override { fonts = [ "Hack" ]; })
			];

			system.activationScripts.applications.text = let
				env = pkgs.buildEnv {
					name = "system-applications";
					paths = config.environment.systemPackages;
					pathsToLink = "/Applications";
				};
			in
				pkgs.lib.mkForce ''
				# Set up applications.
				echo "setting up /Applications..." >&2
				rm -rf /Applications/Nix\ Apps
				mkdir -p /Applications/Nix\ Apps
				find ${env}/Applications -maxdepth 1 -type l -exec readlink '{}' + |
				while read -r src; do
					app_name=$(basename "$src")
					echo "copying $src" >&2
					${pkgs.mkalias}/bin/mkalias "$src" "/Applications/Nix Apps/$app_name"
				done
						'';
			
			system.defaults = {
				dock.autohide = true;
			};

			homebrew = {
				enable = true;
				brews = [
					"git"
					"node"
					"ntfy"
					"pandoc"
					"starship"
				];
				casks = [
					"anaconda"
					"arc"
					"cheatsheet"
					"cursor"
					"google-chrome"
					"hammerspoon"
					"karabiner-elements"
					"lm-studio"
					"loopback"
					"microsoft-teams"
					"obsidian"
					"pallotron-yubiswitch"
					"pika"
					"raycast"
					"setapp"
					"steam"
					"visual-studio-code"
					"vmware-horizon-client"
					"warp"
					"yubico-yubikey-manager"
				];
				taps = [
				];
				onActivation.cleanup = "zap";
				onActivation.autoUpdate = true;
				onActivation.upgrade = true;
			};

      # Necessary for using flakes on this system.
      nix.settings.experimental-features = "nix-command flakes";

      # Enable alternative shell support in nix-darwin.
      # programs.fish.enable = true;

      # Set Git commit hash for darwin-version.
      system.configurationRevision = self.rev or self.dirtyRev or null;

      # Used for backwards compatibility, please read the changelog before changing.
      # $ darwin-rebuild changelog
      system.stateVersion = 5;

      # The platform the configuration will be used on.
      nixpkgs.hostPlatform = "aarch64-darwin";
    };
  in
  {
    # Build darwin flake using:
    # $ darwin-rebuild build --flake .#simple
    darwinConfigurations."m4macbook" = nix-darwin.lib.darwinSystem {
      modules = [ 
	  configuration 
	  nix-homebrew.darwinModules.nix-homebrew
	  {
	    nix-homebrew = {
	      enable = true;
	      enableRosetta = true;
	      user = "chase";
	    };
	  }
	];
    };

    # Expose the package set, including overlays, for convenience.
    darwinPackages = self.darwinConfigurations."m4macbook".pkgs;
  };
}
