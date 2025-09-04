{
  pkgs,
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.greetd.quickshell;

  quickshell = inputs.quickshell.packages.${pkgs.stdenv.system}.default;
  dots = inputs.dots.packages.${pkgs.stdenv.system}.default;
in {
  options.services.greetd.quickshell = {
    enable = mkEnableOption "quickshell";
  };

  config = let
    hyprConfig = pkgs.writeText "greetd-hyprland-config" ''
      misc {
        disable_hyprland_logo = true;
        disable_splash_rendering = true;
      }

      exec-once = ${quickshell}/bin/quickshell -p ${dots}/etc/quickshell/greeter.qml
    '';
  in
    mkIf cfg.enable {
      services.greetd = {
        settings = {
          default_session = {
            command = "${pkgs.hyprland}/bin/Hyprland --config ${hyprConfig}";
          };
        };
      };
    };
}
