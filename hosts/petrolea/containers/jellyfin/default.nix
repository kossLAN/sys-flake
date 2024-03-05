{
  lib,
  deployment,
  pkgs,
  ...
}: {
  deployment.containers.br0 = [{name = "jellyfin";}];

  containers.jellyfin = deployment.mkContainer {
    hostBridge = "br0";
    hostAddress = deployment.containerHostIp "br0";
    localAddress = "${deployment.containerLocalIp "br0" "jellyfin"}/24";

    # Pass Intel Arc GPU to container
    allowedDevices = [
      {
        node = "/dev/dri/renderD128";
        modifier = "rw";
      }
    ];

    bindMounts = {
      "/dev/dri/renderD128".isReadOnly = false;
      "/media".isReadOnly = false;

      "/var/lib/jellyfin" = {
        isReadOnly = false;
        hostPath = "/var/lib/nixos-mounts/jellyfin/jellyfin";
      };

      "/var/cache/jellyfin" = {
        isReadOnly = false;
        hostPath = "/var/lib/nixos-mounts/jellyfin/jellyfin-cache";
      };
    };

    config = {...}: {
      nixpkgs.config.allowUnfree = true;

      networking = {
        firewall.enable = false;
        useHostResolvConf = lib.mkForce false;
        nameservers = deployment.nameservers;
        defaultGateway.address = deployment.containerLocalIp "br0" "router-fa0";
        extraHosts = "${deployment.containerLocalIp "br0" "arr"} arr";
      };

      users = {
        users.jellyfin.uid = lib.mkForce 1000;
        groups.jellyfin.gid = lib.mkForce 1000;
      };

      services = {
        jellyfin.enable = true;
        jellyseerr.enable = true;
      };

      environment = {
        systemPackages = with pkgs; [intel-gpu-tools];
        sessionVariables = {LIBVA_DRIVER_NAME = "iHD";};
      };

      hardware.graphics = {
        enable = true;
        extraPackages = with pkgs; [
          vpl-gpu-rt
          intel-ocl
          intel-media-driver
        ];
      };

      # Tell jellyfin to request right driver...
      systemd.services.jellyfin.environment.LIBVA_DRIVER_NAME = "iHD";

      # Build FFMPEG with VPL support
      nixpkgs.overlays = [
        (
          _: prev: {
            jellyfin-ffmpeg = prev.jellyfin-ffmpeg.override {
              ffmpeg_7-full = prev.ffmpeg_7-full.override {
                withMfx = false;
                withVpl = true;
                withUnfree = true;
              };
            };
          }
        )
      ];

      system.stateVersion = "24.11";
    };
  };
}
