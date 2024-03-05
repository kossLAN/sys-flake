{
  lib,
  pkgs,
  deployment,
  ...
}: {
  deployment.containers.br0 = [{name = "arr";}];

  containers.arr = deployment.mkContainer {
    hostBridge = "br0";
    hostAddress = deployment.containerHostIp "br0";
    localAddress = "${deployment.containerLocalIp "br0" "arr"}/24";

    bindMounts = {
      "/media".isReadOnly = false;
      "/srv/torrents".isReadOnly = false;
    };

    config = {...}: {
      networking = {
        firewall.enable = false;
        useHostResolvConf = lib.mkForce false;
        nameservers = deployment.nameservers;
        defaultGateway.address = deployment.containerLocalIp "br0" "router-fa0";
        extraHosts = "${deployment.containerLocalIp "br0" "deluge"} deluge";
      };

      nixpkgs.config.permittedInsecurePackages = [
        "dotnet-sdk-6.0.428"
        "aspnetcore-runtime-6.0.36"
      ];

      users = {
        users.arr = {
          isSystemUser = true;
          group = "arr";
          uid = 1000;
        };

        groups.arr.gid = 1000;
      };

      services = let
        user = "arr";
        group = "arr";
      in {
        prowlarr = {
          enable = true;
          package = pkgs.unstable.prowlarr;
        };

        sonarr = {
          inherit user group;
          enable = true;
          package = pkgs.unstable.sonarr;
        };

        radarr = {
          inherit user group;
          enable = true;
          package = pkgs.unstable.radarr;
        };

        lidarr = {
          inherit user group;
          enable = true;
          package = pkgs.unstable.lidarr;
        };

        flaresolverr = {
          enable = true;
          package = pkgs.unstable.flaresolverr;
        };
      };

      system.stateVersion = "25.11";
    };
  };
}
