{
  nixpkgs,
  system,
  hostName,
}: let
  myvars = {
    user = "wayjamsu";
    gitUser = "WayJam So";
    gitUserEmail = "imsuwj@gmail.com";
  };
  # user level
  mycfgs = {
    my.dev.enable = true;
    my.squirrel.enable = true;
    my.tmux.enable = true;
    my.mediaCollections.enable = true;
    my.ollama.enable = true;
  };
in {
  root = {
    system.stateVersion = 4;
  };

  myvars = myvars;

  module = {
    config,
    pkgs,
    lib,
    ...
  }: {
    # sys level
    my.chineseFont.enable = true;

    imports = [
      ../modules/font
    ];

    nix.extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

    home-manager.users.${myvars.user} = mycfgs;
  };
}
