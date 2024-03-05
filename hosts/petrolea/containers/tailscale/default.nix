{
  config,
  self,
  deployment,
  lib,
  ...
}: {
  deployment.containers.br0 = [{name = "tailscale";}];

  containers.tailscale = deployment.mkContainer {
    enableTun = true;
    hostBridge = "br0";
    hostAddress = deployment.containerHostIp "br0";
    localAddress = "${deployment.containerLocalIp "br0" "tailscale"}/24";

    config = {...}: {
      imports = [
        (self.outPath + "/modules/server/services/caddy")
        (self.outPath + "/modules/server/deployment")
      ];

      networking = {
        hostName = "tailscale";
        firewall.enable = true;
        nameservers = deployment.nameservers;
        useHostResolvConf = lib.mkForce false;
        defaultGateway.address = deployment.containerLocalIp "br0" "router-fa0";

        nat = {
          enable = true;
          externalInterface = "tailscale0";
          internalInterfaces = ["eth0"];

          forwardPorts = [
            # ssh
            {
              sourcePort = 22;
              proto = "tcp";
              destination = "${deployment.containerHostIp "br0"}:22";
            }
          ];
        };
      };

      services = {
        tailscale = {
          enable = true;
          openFirewall = true;
          useRoutingFeatures = "both";
        };

        caddy = {
          enable = true;
          cfKeyFile = config.age.secrets.cloudflare.path;
          domains = {
            "kosslan.me" = {
              extraDomains = [
                "sync.petrolea.kosslan.me"
              ];

              reverseProxyList = [
                {
                  subdomain = "sync.petrolea";
                  address = deployment.containerLocalIp "br0" "syncthing";
                  port = 8384;
                }
                {
                  subdomain = "plausible";
                  address = deployment.containerLocalIp "br0" "plausible";
                  port = 8000;
                }
                {
                  subdomain = "deluge";
                  address = deployment.containerLocalIp "br0" "deluge";
                  port = 8112;
                }
                {
                  subdomain = "lidarr";
                  address = deployment.containerLocalIp "br0" "arr";
                  port = 8686;
                }
                {
                  subdomain = "sonarr";
                  address = deployment.containerLocalIp "br0" "arr";
                  port = 8989;
                }
                {
                  subdomain = "radarr";
                  address = deployment.containerLocalIp "br0" "arr";
                  port = 7878;
                }
                {
                  subdomain = "prowlarr";
                  address = deployment.containerLocalIp "br0" "arr";
                  port = 9696;
                }
              ];
            };
          };
        };
      };

      system.stateVersion = "25.11";
    };

    bindMounts."${config.age.secrets.cloudflare.path}".isReadOnly = true;
  };
}
