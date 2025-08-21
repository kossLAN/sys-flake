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
    enable = mkEnableOption "A QT based shell for wayland compositors";

    systemd.enable = mkEnableOption {
      default = true;
      description = "Enable systemd service to launch quickshell";
    };

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

    config = mkOption {
      type = lib.types.package;
      default = inputs.dots.packages.${pkgs.stdenv.system}.default;
    };
  };

  config = mkIf cfg.enable {
    environment = {
      etc."xdg/quickshell".source = "${cfg.config}/etc/quickshell";

      systemPackages = [
        # qt stuff
        cfg.package
        pkgs.qt6.qtwayland
        pkgs.qt6.qt5compat
        pkgs.qt6.qtdeclarative

        # icons
        pkgs.papirus-icon-theme

        # utils
        pkgs.grim
      ];
    };

    fonts.packages = with pkgs; [
      material-symbols
      material-icons
    ];

    systemd.user.services.quickshell = mkIf cfg.systemd.enable {
      enable = true;
      description = "Quickshell Service";
      wantedBy = ["graphical-session.target"];
      path = lib.mkForce []; # forces it to allow it to access path

      serviceConfig = {
        Type = "simple";
        ExecStart = "${cfg.package}/bin/quickshell --config /etc/xdg/quickshell";
        Restart = "on-failure";
      };
    };
  };
}
