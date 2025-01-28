{
  config,
  lib,
  pkgs,
  ...
}:
with lib; let
  cfg = config.my.ollama;
in {
  options.my.ollama = {
    enable = mkEnableOption "Ollama";
  };

  config = mkIf cfg.enable {
      services.ollama = {
        enable = true;
      };
  };
}
