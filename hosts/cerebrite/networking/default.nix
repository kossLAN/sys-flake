{deployment, ...}: {
  services = {
    tailscale = {
      enable = true;
      useRoutingFeatures = "both";

      extraUpFlags = [
        "--login-server=https://kosslan.me"
        "--advertise-routes=192.168.0.0/20"
      ];
    };

    caddy = {
      enable = true;

      domains = let
        localhost = "localhost";
      in {
        "kosslan.me" = {
          reverseProxyList = [
            {
              subdomain = "deluge";
              address = deployment.containerHostIp "deluge";
              port = 8112;
            }
            {
              subdomain = "sonarr";
              address = localhost;
              port = 8989;
            }
            {
              subdomain = "radarr";
              address = localhost;
              port = 7878;
            }
            {
              subdomain = "lidarr";
              address = localhost;
              port = 8686;
            }
            {
              subdomain = "prowlarr";
              address = localhost;
              port = 9696;
            }
            {
              subdomain = "sync";
              address = localhost;
              port = 8384;
            }
            {
              subdomain = "chat";
              address = localhost;
              port = 12121;
            }
            {
              subdomain = "netdata";
              address = localhost;
              port = 19999;
            }
            {
              subdomain = "jellyfin";
              address = localhost;
              port = 8096;
            }
          ];
        };
      };
    };
  };

  networking = {
    hostId = "0dcbd9ac";
    networkmanager.enable = true;
    firewall.allowedTCPPorts = [443 80];
    nameservers = ["1.1.1.1" "8.8.8.8"];
  };
}
