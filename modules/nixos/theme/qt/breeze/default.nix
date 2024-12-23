{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.theme.qt.breeze;
in {
  options.theme.qt.breeze = {
    enable = mkEnableOption "Enable Breeze QT theme";
  };

  config = mkIf cfg.enable {
    theme.qt = {
      enable = true;
      style = "Breeze";
      kdeColorScheme = "BreezeDark";
      kdeGlobals = ./kdeglobals;

      qt5 = {
        package = pkgs.libsForQt5.breeze-qt5;
        colors = ./colors-qt5.conf;
      };

      qt6 = {
        package = pkgs.kdePackages.breeze;
        colors = ./colors-qt6.conf;
      };

      icons = {
        name = "breeze-dark";
        package = pkgs.kdePackages.breeze-icons;
      };
    };
  };
}
