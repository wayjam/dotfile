{
  lib,
  pkgs,
  config,
  ...
}: {
  programs.alacritty = {
    # using Homebrew
    enable = false;
  };
  xdg.configFile = {
    "alacritty/alacritty.toml" = {
      source = ./alacritty.toml;
    };
  };
}
