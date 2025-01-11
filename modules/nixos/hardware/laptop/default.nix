{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.hardware.mobile;
in {
  options.hardware.mobile = {
    enable = mkEnableOption "Mobile power management configuration";
  };

  config = mkIf cfg.enable {
    powerManagement = {
      enable = true;
      powertop.enable = true;
      cpuFreqGovernor = "powersave";
    };

    security.protectKernelImage = false;

    programs = {
      light = {
        enable = true;
        brightnessKeys.enable = true;
      };
    };

    services = {
      power-profiles-daemon.enable = false;
      upower.enable = true;
      fprintd.enable = true;

      libinput = {
        enable = true;

        touchpad = {
          clickMethod = "clickfinger";
        };
      };

      auto-cpufreq = {
        enable = true;

        settings = {
          battery = {
            governor = "powersave";
            turbo = "never";
          };
          charger = {
            governor = "ondemand";
            turbo = "auto";
          };
        };
      };
    };

    # Kernel Laptop Parameters
    boot.kernelParams = [
      "quiet"
      "splash"
    ];
  };
}
