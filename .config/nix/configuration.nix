{ config, pkgs, lib, self, ... }: {
   security.pam.services.sudo_local = {
    enable = true;
    reattach = true;
    touchIdAuth = true;
    watchIdAuth = true;
  };

  # Set primary user for homebrew and system defaults
  system.primaryUser = "chase";

  environment.systemPackages = [ 
    pkgs.vim
    pkgs.pam-watchid
  ];

  fonts.packages = [
    pkgs.nerd-fonts.hack
  ];

  # Removed applications activation script to prevent conflicts with Homebrew casks
  # Homebrew casks install directly to /Applications and don't need Nix management

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
      "docker-compose"
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
      "openjdk"
      "jenv"
      "deno"
      "bun"
      "mas"
      "neovim"
      "mongosh"
      { name = "mongodb/brew/mongodb-community"; trusted = true; }
      "ffmpeg"
      "docker-compose"
      "docker"
      "poppler"
      "redis"
      "colima" 
      "flyctl"
      "yt-dlp"
      "cmake"
      "fswatch"
      "tailscale"
      "openconnect"
    ];
    casks = [
      "keyboardcleantool"
      "anaconda"
      "forklift"
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
      "devin-desktop"
      "loopback"
      "audio-hijack"
      "trae"
      "openvpn-connect"
      "moonlight"
      "citrix-workspace"
      "jiggler"
      "the-unarchiver"
      "sigmaos"
      "zen"
      "sony-ps-remote-play"
      "vlc"
      "jump-desktop-connect"
      "handbrake-app"
      "todoist-app"
      "libreoffice"
      "insomnia"
      "dotnet-sdk"
      "gamemaker"
      "claude-code"
      "claude"
      "logi-options+"
      "iina"
      "dockdoor"
      "mutedeck"
      "tailscale-app"
      "the-unarchiver"
      "epic-games"
      "crossover"
      "cyberduck"
      "transnomino"
      "omnigraffle"
      "antinote"
      "commander-one"
      "temurin@25"
      "ollama-app"
    ];
    masApps = {
      # "Xcode" = 497799835;
      # "Folder Preview" = 6698876601;
    };
    taps = [
      { name = "oven-sh/bun"; trusted = true; }
      { name = "mongodb/brew"; trusted = true; }
      { name = "heroku/brew"; trusted = true; }
    ];
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  system.configurationRevision = self.rev or self.dirtyRev or null;
  system.stateVersion = 5;
  nixpkgs.hostPlatform = "aarch64-darwin";

  # docker-completion is deprecated and conflicts with the docker formula's completions
  system.activationScripts.preActivation.text = lib.mkAfter ''
    if [ -x /opt/homebrew/bin/brew ]; then
      /opt/homebrew/bin/brew unlink docker-completion 2>/dev/null || true
      /opt/homebrew/bin/brew uninstall --ignore-dependencies docker-completion 2>/dev/null || true
    fi
  '';
}
