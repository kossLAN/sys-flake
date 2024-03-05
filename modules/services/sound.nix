{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.sound;
in {
  # This is also going to be the same across my linux installs so best to abstract.
  options.services.sound = {
    enable = mkEnableOption "sound";
    lowLatency.enable = mkEnableOption "Low latency toggle";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = [
      pkgs.lxqt.pavucontrol-qt
    ];

    services = {
      pipewire = {
        enable = true;
        audio.enable = true;
        wireplumber.enable = true;

        extraConfig.pipewire."92-low-latency" = mkIf cfg.lowLatency.enable {
          "context.properties" = {
            "default.clock.rate" = 48000;
            "default.clock.quantum" = 32;
            "default.clock.min-quantum" = 32;
            "default.clock.max-quantum" = 32;
          };
        };

        pulse.enable = true;
        jack.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };
    };

    security = {
      rtkit.enable = true;
    };

    users.users.${config.users.defaultUser}.extraGroups = [
      "pipewire"
      "audio"
    ];
  };
}
