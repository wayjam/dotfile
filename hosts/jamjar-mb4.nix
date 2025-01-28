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
    imports = [
    ];

    nix.extraOptions = ''
      extra-platforms = x86_64-darwin aarch64-darwin
    '';

    home-manager.users.${myvars.user} = {
      my.dev.enable = true;
      my.squirrel.enable = true;
      my.tmux.enable = true;
      my.mediaCollections.enable = true;
      my.chineseFont.enable = true;
      my.ollama.enable = true;
    };
  };
}
