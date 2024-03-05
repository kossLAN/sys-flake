{
  self,
  lib,
  deployment,
  ...
}: {
  deployment.containers.br0 = [
    {
      name = "router-fa2";
      priority = 2;
    }
  ];

  containers.router-fa2 = deployment.mkContainer {
    hostBridge = "fa0";

    # We use br0 as our lan network, and then use nat to route out to the internet
    extraVeths.lan2 = {
      hostBridge = "br0";
      hostAddress = deployment.containerHostIp "br0";
      localAddress = "${deployment.containerLocalIp "br0" "router-fa2"}/24";
    };

    config = {...}: {
      imports = [
        (self.outPath + "/modules/server/services/caddy")
        (self.outPath + "/modules/server/deployment")
      ];

      networking = {
        nameservers = deployment.nameservers;
        useHostResolvConf = lib.mkForce false;

        firewall = {
          enable = true;
          allowedTCPPorts = [80 443];
        };

        nat = {
          enable = true;
          externalInterface = "eth0";
          internalInterfaces = ["lan2"];

          forwardPorts = [
            {
              destination = "${deployment.containerLocalIp "br0" "game"}:10000-65535";
              proto = "tcp";
              sourcePort = "10000:65535";
            }
            {
              destination = "${deployment.containerLocalIp "br0" "game"}:10000-65535";
              proto = "udp";
              sourcePort = "10000:65535";
            }
          ];
        };
      };

      systemd.network = {
        enable = true;

        networks = {
          "10-wan" = {
            linkConfig.RequiredForOnline = "routable";
            dns = deployment.nameservers;
            addresses = [{Address = "38.129.141.45/29";}];

            routes = [
              {
                Gateway = deployment.containerHostIp "br0";
                GatewayOnLink = true;
              }
            ];

            matchConfig = {
              Virtualization = "container";
              Name = "eth0";
            };

            networkConfig = {
              DHCP = "no";
              LLDP = "yes";
              EmitLLDP = "customer-bridge";
            };
          };
        };
      };

      system.stateVersion = "25.05";
    };
  };
}
