{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.theme.qt.catppuccin;
  catpuccinQt5ct = pkgs.fetchFromGitHub {
    owner = "catppuccin";
    repo = "qt5ct";
    rev = "0442cc931390c226d143e3a6d6e77f819c68502a";
    hash = "sha256-hXyPuI225WdMuVSeX1AwrylUzNt0VA33h8C7MoSJ+8A=";
  };
in {
  options.theme.qt.catppuccin = {
    enable = mkEnableOption "Enable Breeze QT theme";
  };

  config = mkIf cfg.enable {
    theme.qt = {
      enable = true;
      style = lib.mkForce "Lightly";
      kdeColorScheme = lib.mkForce "Lightly";

      breeze.enable = true; # Fall back to breeze for qt6

      qt5 = {
        package = lib.mkForce pkgs.lightly-qt;
        colors = lib.mkForce "${catpuccinQt5ct}/themes/catppuccin-macchiato-sky.conf";
      };
    };
  };
}
