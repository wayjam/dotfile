{
  config,
  lib,
  pkgs,
  rime-plum,
  ...
}:
with lib; let
  cfg = config.my.squirrel;
in {
  options.my.squirrel = {
    enable = mkEnableOption "Enable Squirrel(rime) with rime-ice";
  };

  config = mkIf cfg.enable {
    home.activation.installRimeIce = lib.hm.dag.entryAfter ["writeBoundary"] ''
      export PATH=${pkgs.git}/bin:$PATH
      WORK_DIR=$(mktemp -d)  # 创建一个临时目录
      echo "Using Temp Dir: $WORK_DIR"
      cp -r ${rime-plum}/* $WORK_DIR  # 将 rime-plum 的内容复制到临时目录
      $WORK_DIR/rime-install iDvel/rime-ice:others/recipes/full
      chmod -R u+rwx $WORK_DIR  && rm -rf $WORK_DIR
    '';

    home.file = {
      "${config.home.homeDirectory}/Library/Rime/default.custom.yaml".source = ./default.custom.yaml;
      "${config.home.homeDirectory}/Library/Rime/squirrel.custom.yaml".source = ./squirrel.custom.yaml;
    };
  };
}
