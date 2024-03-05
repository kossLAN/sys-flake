{
  lib,
  deployment,
  ...
}: {
  deployment.containers.br0 = [{name = "plex";}];

  containers.plex = deployment.mkContainer {
    hostBridge = "br0";
    hostAddress = deployment.containerHostIp "br0";
    localAddress = "${deployment.containerLocalIp "br0" "plex"}/24";

    bindMounts = {
      "/media".isReadOnly = false;
    };

    config = {...}: {
      nixpkgs.config.allowUnfree = true;

      networking = {
        firewall.enable = false;
        useHostResolvConf = lib.mkForce false;
        nameservers = deployment.nameservers;
        defaultGateway.address = deployment.containerLocalIp "br0" "router-fa0";
      };

      users = {
        groups.plex.gid = lib.mkForce 1000;

        users.plex = {
          uid = lib.mkForce 1000;
          isSystemUser = true;
        };
      };

      services = {
        plex.enable = true;
      };

      system.stateVersion = "24.11";
    };
  };
}
