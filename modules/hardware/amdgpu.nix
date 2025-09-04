{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.hardware.amdgpu;
in {
  options.hardware.amdgpu = {
    enable = mkEnableOption "AMD common settings";
  };

  config = mkIf cfg.enable {
    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
        extraPackages = with pkgs; [rocmPackages.clr.icd];
      };

      amdgpu = {
        initrd.enable = true;
        # amdvlk = {
        #   enable = true;
        #   support32Bit.enable = true;
        # };

        overdrive = {
          enable = true;
          ppfeaturemask = "0xffffffff";
        };
      };
    };

    systemd.tmpfiles.rules = [
      "L+    /opt/rocm/hip   -    -    -     -    ${pkgs.rocmPackages.clr}"
    ];

    services = {
      libinput.enable = true;

      xserver = {
        enable = true;

        videoDrivers = ["amdgpu"];
        xkb.layout = "us";
      };
    };
  };
}
