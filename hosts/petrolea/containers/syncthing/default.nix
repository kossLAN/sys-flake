{deployment, ...}: {
  deployment.containers.br0 = [{name = "syncthing";}];

  containers.syncthing = {
    autoStart = true;
    privateNetwork = true;
    hostBridge = "br0";
    hostAddress = deployment.containerHostIp "br0";
    localAddress = "${deployment.containerLocalIp "br0" "syncthing"}/24";

    bindMounts = {
      "/media" = {
        hostPath = "/media";
        isReadOnly = false;
      };
    };

    config = {lib, ...}: {
      networking = {
        firewall.enable = false;
        useHostResolvConf = lib.mkForce false;
        nameservers = deployment.nameservers;
        defaultGateway.address = deployment.containerLocalIp "br0" "router-fa0";
      };

      users = {
        users.syncthing = {
          uid = lib.mkForce 1000;
          isSystemUser = true;
        };

        groups.syncthing.gid = lib.mkForce 1000;
      };

      services.syncthing = {
        enable = true;
        guiAddress = "0.0.0.0:8384";
        openDefaultPorts = true;
        overrideFolders = false;
        overrideDevices = false;
      };

      system.stateVersion = "24.11";
    };
  };
}
