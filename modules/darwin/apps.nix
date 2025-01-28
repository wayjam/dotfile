{pkgs, ...}: {
  ##########################################################################
  #
  #  Install all apps and packages here.
  #
  #  NOTE: Your can find all available options in:
  #    https://daiderd.com/nix-darwin/manual/index.html
  #
  ##########################################################################

  # Install packages from nix's official package repository.
  #
  # The packages installed here are available to all users, and are reproducible across machines, and are rollbackable.
  # But on macOS, it's less stable than homebrew.
  #
  # Related Discussion: https://discourse.nixos.org/t/darwin-again/29331
  environment.systemPackages = with pkgs; [
    git
    just # use Justfile to simplify nix-darwin's commands
  ];

  # NOTE: Homebrew need to be installed manually, see https://brew.sh
  #
  # The apps installed by homebrew are not managed by nix, and not reproducible!
  # But on macOS, homebrew has a much larger selection of apps than nixpkgs, especially for GUI apps!
  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true; # Fetch the newest stable branch of Homebrew's git repo
      upgrade = true; # Upgrade outdated casks, formulae, and App Store apps
      # 'zap': uninstalls all formulae(and related files) not listed in the generated Brewfile
      # cleanup = "zap";
    };

    taps = [
      "homebrew/services"
      "buo/cask-upgrade"
    ];

    # Applications to install from Mac App Store using mas.
    # You need to install all these Apps manually first so that your apple account have records for them.
    # otherwise Apple Store will refuse to install them.
    # For details, see https://github.com/mas-cli/mas
    masApps = {
      # Xcode = 497799835;
      # Wechat = 836500024;
      # QQ = 451108668;
    };

    # `brew install`
    brews = [
      "mas"
      "reattach-to-user-namespace"
      # "hugo"

      # # langs
      # "rustup" # rust
      # "go"
      # "nvm" # nodejs
      # "python"
      # "lua"
      # "luarocks"
      # "clang-format"
    ];

    # `brew install --cask`
    casks = [
      # dev
      "alacritty"
      "visual-studio-code"

      # tools
      "appcleaner"
      "dropbox"
      "input-source-pro"
      "keyboard-cleaner"
      "mac-mouse-fix"
      "snipaste"
      "omnidisksweeper"
      "the-unarchiver"
      "raycast"
      "bitwarden"

      # ime
      "squirrel"

      # browsers
      "google-chrome"

      # communication

      # media
      "iina"

      # others
      "clash-verge-rev"

      # note & knowledge
      "notion"
      "obsidian"

      # virtualization
      "orbstack"
      "utm"
    ];
  };
}
