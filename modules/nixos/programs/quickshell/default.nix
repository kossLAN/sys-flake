{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.programs.quickshell;
in {
  options.programs.quickshell = {
    enable = mkEnableOption "A qtquick based shell for wayland compositors";

    package = mkOption {
      type = lib.types.package;
      default = inputs.quickshell.packages.${pkgs.stdenv.system}.default.override {
        withJemalloc = true;
        withQtSvg = true;
        withWayland = true;
        withX11 = true;
        withPipewire = true;
        withPam = true;
        withHyprland = true;
      };
    };
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [cfg.package];

    systemd.user.services.quickshell = {
      enable = true;
      description = "Quickshell Service";
      wantedBy = ["graphical-session.target"];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/quickshell";
        Restart = "on-failure";
      };
    };
  };
}
