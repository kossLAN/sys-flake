{
  self,
  config,
  lib,
  deployment,
  ...
}: {
  deployment.containers.br0 = [
    {
      name = "router-fa0";
      priority = 0;
    }
  ];

  containers.router-fa0 = deployment.mkContainer {
    hostBridge = "fa0";

    # We use br0 as our lan network, and then use nat to route out to the internet
    # NOTE: these are shared with the host for some reason and cant use same interface name...
    extraVeths.lan0 = {
      hostBridge = "br0";
      hostAddress = deployment.containerHostIp "br0";
      localAddress = "${deployment.containerLocalIp "br0" "router-fa0"}/24";
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
          internalInterfaces = ["lan0"];

          # forward ports from containers, same for other router containers
          forwardPorts = [
            # Forgejo
            {
              destination = "${deployment.containerLocalIp "br0" "forgejo"}:2000";
              proto = "tcp";
              sourcePort = 22;
            }

            # Syncthing
            {
              sourcePort = 22000;
              proto = "tcp";
              destination = "${deployment.containerLocalIp "br0" "syncthing"}:22000";
            }
            {
              sourcePort = 21027;
              proto = "udp";
              destination = "${deployment.containerLocalIp "br0" "syncthing"}:21027";
            }

            # Plex
            {
              sourcePort = 32400;
              proto = "tcp";
              destination = "${deployment.containerLocalIp "br0" "plex"}:32400";
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
            addresses = [{Address = "38.129.141.43/32";}];

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
        cfKeyFile = config.age.secrets.cloudflare.path;
        domains = {
          "kosslan.dev" = {
            reverseProxyList = [
              # Forgejo Git Instance
              {
                subdomain = "git";
                address = deployment.containerLocalIp "br0" "forgejo";
                port = 4000;
              }

              # Matrix Instance
              {
                subdomain = "matrix";
                extraConfig = ''
                  reverse_proxy /_matrix/* ${deployment.containerLocalIp "br0" "matrix"}:8008
                  reverse_proxy /_synapse/client/* ${deployment.containerLocalIp "br0" "matrix"}:8008
                '';
              }
              {
                extraConfig = ''
                  header /.well-known/matrix/* Content-Type application/json
                  header /.well-known/matrix/* Access-Control-Allow-Origin *

                  respond /.well-known/matrix/server `{
                    "m.server": "matrix.kosslan.dev:443"
                  }`

                  respond /.well-known/matrix/client `{
                    "m.homeserver": {
                      "base_url": "https://matrix.kosslan.dev"
                    },
                    "org.matrix.msc3575.proxy": {
                      "url": "https://matrix.kosslan.dev"
                    }
                  }`
                '';
              }
            ];
          };

          "kosslan.me" = {
            reverseProxyList = [
              # jellyfin
              {
                subdomain = "jellyfin";
                address = deployment.containerLocalIp "br0" "jellyfin";
                port = 8096;
              }
              {
                subdomain = "seer";
                address = deployment.containerLocalIp "br0" "jellyfin";
                port = 5055;
              }
            ];
          };
        };
      };

      system.stateVersion = "25.11";
    };

    bindMounts."${config.age.secrets.cloudflare.path}".isReadOnly = true;
  };
}
