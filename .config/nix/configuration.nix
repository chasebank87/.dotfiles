{ config, pkgs, lib, self, ... }: {
   security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
    watchIdAuth = true;
  };

  {
  nixpkgs.overlays = [
    (self: super: {
      pam-watchid = super.stdenv.mkDerivation {
        name = "pam-watchid";
        src = super.fetchFromGitHub {
          owner = "insidegui";
          repo = "pam-watchid";
          rev = "master"; # You might want to use a specific commit hash for stability
          sha256 = ""; # You'll need to replace this with the correct hash
        };
        buildPhase = "make";
        installPhase = "make install";
      };
    })
  ];


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

  system.defaults.dock = {
    autohide = true;
    show-recents = false;
    persistent-apps = [
      "/Applications/Warp.app"
      "/Applications/Arc.app"
      "/Applications/Cursor.app"
      "/Applications/Obsidian.app"
      "/Applications/Visual Studio Code.app"
      "/System/Applications/Messages.app"
      "/System/Applications/Mail.app"
      "/System/Applications/Calendar.app"
      "/System/Applications/FaceTime.app"
      "/System/Applications/Maps.app"
      "/System/Applications/Music.app"
      "/System/Applications/Photos.app"
      "/System/Applications/Reminders.app"
      "/System/Applications/iPhone Mirroring.app"
    ];
    persistent-others = [
      "/Applications"
      "/Users/chase/Downloads"
    ];
  };

  system.defaults.finder = {
    FXPreferredViewStyle = "clmv";
    FXDefaultSearchScope = "SCcf";
    NewWindowTarget = "Home";
    ShowPathbar = true;
    ShowStatusBar = true;
    _FXSortFoldersFirst = true;
    FXEnableExtensionChangeWarning = false;
  };

  homebrew = {
    enable = true;
    brews = [
      "git"
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
    ];
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
      "loopback"
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
    ];
    taps = [
    ];
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  nix.settings.experimental-features = "nix-command flakes";
  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";
}
