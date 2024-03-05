{
  lib,
  deployment,
  config,
  ...
}: let
  externalInterface = "enp35s0";
in {
  networking = {
    hostId = "8425e349"; # Needed for zfs
    nameservers = deployment.nameservers;
    firewall.enable = true;
    firewall.allowedTCPPorts = [5201];

    # nat = {
    #   enable = true;
    #   inherit externalInterface;
    #   internalInterfaces = ["br0"];
    # };
  };

  # systemd.services."systemd-networkd".environment.SYSTEMD_LOG_LEVEL = "debug";

  systemd.network = {
    enable = true;

    netdevs = {
      "20-br0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "br0";
        };
      };

      "30-fa0" = {
        netdevConfig = {
          Kind = "bridge";
          Name = "fa0";
        };

        bridgeConfig = {
          STP = false;
          ForwardDelaySec = 1;
        };
      };
    };

    networks = {
      # Configure all nics on host with dhcp
      "10-wan" = {
        matchConfig.Name = "en*";
        networkConfig.DHCP = "yes";
        linkConfig.RequiredForOnline = "no";

        # Setup fallback on DHCP
        # addresses = [{Address = "38.129.141.42/32";}];
        # routes = [{Gateway = "38.129.141.41/32";}];
      };

      # LAN network for inter container communication
      "40-br0" = {
        matchConfig.Name = "br0";
        linkConfig.RequiredForOnline = "carrier";
        bridgeConfig = {};

        addresses = [
          {Address = "${deployment.containerHostIp "br0"}/24";}
        ];
      };

      "50-fa0" = {
        matchConfig.Name = "fa0";
        linkConfig.RequiredForOnline = "carrier";
        dns = deployment.nameservers;
        bridgeConfig = {};

        addresses = [
          {Address = "38.129.141.42/32";}
        ];

        # NOTE: can maybe use /29 netmask might work, dunno
        routes = [
          {
            Destination = "38.129.141.42/29";
            Scope = "link";
          }
        ];
      };
    };
  };

  boot = {
    kernelModules = ["wireguard"];

    kernel.sysctl = {
      "net.ipv4.conf.${externalInterface}.proxy_arp" = lib.mkDefault true;
      "net.ipv4.ip_forward" = 1;
    };
  };
}
