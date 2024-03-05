{
  lib,
  deployment,
  config,
  ...
}: {
  deployment.containers.br0 = [{name = "plausible";}];

  containers.plausible = deployment.mkContainer {
    hostBridge = "br0";
    hostAddress = deployment.containerHostIp "br0";
    localAddress = "${deployment.containerLocalIp "br0" "plausible"}/24";

    bindMounts = {
      "${config.age.secrets.plausible-admin.path}".isReadOnly = true;
      "${config.age.secrets.plausible-keybase.path}".isReadOnly = true;
    };

    config = {...}: {
      networking = {
        firewall.enable = false;
        useHostResolvConf = lib.mkForce false;
        nameservers = deployment.nameservers;
        defaultGateway.address = deployment.containerLocalIp "br0" "router-fa0";
      };

      services.plausible = {
        enable = true;

        server = {
          listenAddress = "0.0.0.0";
          port = 8000;
          disableRegistration = true;
          baseUrl = "https://plausible.kosslan.me";
          secretKeybaseFile = config.age.secrets.plausible-keybase.path;
        };
      };

      system.stateVersion = "25.05";
    };
  };
}
