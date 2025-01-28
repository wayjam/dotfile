{
  lib,
  pkgs,
  config,
  ...
}: let
  vimConfig = pkgs.fetchFromGitHub {
    owner = "wayjam";
    repo = "vim-config";
    rev = "develop";
    sha256 = "sha256-KuoHD8EbVbN19oVIzr7lOmWSqbbAJKtNEaj97bTl5t0=";
  };
in {
  programs.neovim = {
    enable = true;
    defaultEditor = true;

    viAlias = true;
    vimAlias = true;

    withPython3 = true;
    withNodeJs = true;

    extraPython3Packages = ps:
      with ps; [
        pillow # for pastify plugin
        pynvim # for pastify plugin
      ];
  };

  # link to ~/.config/nvim
  xdg.configFile = {
    "nvim" = {
      source = vimConfig;
    };
  };
}
