{
  pkgs,
  lib,
  deployment,
  ...
}: {
  deployment.containers.br0 = [{name = "game";}];

  containers.game = deployment.mkContainer {
    enableTun = true;
    extraFlags = ["--system-call-filter=@keyring" "--system-call-filter=bpf"];
    hostBridge = "br0";
    hostAddress = deployment.containerHostIp "br0";
    localAddress = "${deployment.containerLocalIp "br0" "game"}/24";

    config = {...}: {
      networking = {
        firewall.enable = false;
        useHostResolvConf = lib.mkForce false;
        nameservers = deployment.nameservers;
        defaultGateway.address = deployment.containerLocalIp "br0" "router-fa2";
      };

      environment.systemPackages = with pkgs; [
        nvim-pkg
      ];

      virtualisation.docker = {
        enable = true;
      };

      system.stateVersion = "25.05";
    };
  };
}
