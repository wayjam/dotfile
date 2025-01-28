{
  config,
  lib,
  pkgs,
  ...
}: {
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    font-awesome
    cardo
    ibm-plex
    meslo-lg
    jetbrains-mono
    cascadia-code
    dejavu_fonts

    # https://github.com/NixOS/nixpkgs/blob/nixos-unstable-small/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
    nerd-fonts.symbols-only # anything need nerd icon(editor, system bar, etc...)
  ];
}
