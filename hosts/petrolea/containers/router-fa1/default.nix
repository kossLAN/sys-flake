{
  self,
  lib,
  deployment,
  ...
}: {
  deployment.containers.br0 = [
    {
      name = "router-fa1";
      priority = 1;
    }
  ];

  containers.router-fa1 = deployment.mkContainer {
    hostBridge = "fa0";

    # We use br0 as our lan network, and then use nat to route out to the internet
    extraVeths.lan1 = {
      hostBridge = "br0";
      hostAddress = deployment.containerHostIp "br0";
      localAddress = "${deployment.containerLocalIp "br0" "router-fa1"}/24";
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
          internalInterfaces = ["lan1"];
        };
      };

      systemd.network = {
        enable = true;

        networks = {
          "10-wan" = {
            linkConfig.RequiredForOnline = "routable";
            dns = deployment.nameservers;
            addresses = [{Address = "38.129.141.44/32";}];

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

      services.caddy = {
        enable = true;

        virtualHosts = {
          ":80" = {
            extraConfig = ''
              header Content-Type text/html
              respond "
                <html>
                  <head><title>Test</title></head>
                  <body>
                    <h3>Literally nothing to see here man.</h3>
                  </body>
                </html>
              "
            '';
          };
        };
      };

      system.stateVersion = "25.11";
    };
  };
}
