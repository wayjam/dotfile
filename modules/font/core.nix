{pkgs, ...}: {
  fonts = {
    # use fonts specified by user rather than default ones
    # enableDefaultPackages = false;

    packages = with pkgs; [
      font-awesome
      cardo
      
      # https://github.com/NixOS/nixpkgs/blob/nixos-unstable-small/pkgs/data/fonts/nerd-fonts/manifests/fonts.json
      nerd-fonts.blex-mono
      nerd-fonts.meslo-lg
      nerd-fonts.jetbrains-mono
      nerd-fonts.caskaydia-cove
      nerd-fonts.dejavu-sans-mono
      nerd-fonts.symbols-only # anything need nerd icon(editor, system bar, etc...)
    ];
  };
}
