{config, ...}: let
  interface = "enp1s0"; # WAN interface
  cerebrite = "100.64.0.4";
  localhost = "localhost";
in {
  services = {
    headscale = {
      enable = true;
      tailnetRecords = [
        {
          name = "sync";
          value = cerebrite;
        }
        {
          name = "cloud";
          value = cerebrite;
        }
        {
          name = "deluge";
          value = cerebrite;
        }
        {
          name = "radarr";
          value = cerebrite;
        }
        {
          name = "sonarr";
          value = cerebrite;
        }
        {
          name = "lidarr";
          value = cerebrite;
        }
        {
          name = "prowlarr";
          value = cerebrite;
        }
        {
          name = "chat";
          value = cerebrite;
        }
        {
          name = "netdata";
          value = cerebrite;
        }
        {
          name = "jellyfin";
          value = cerebrite;
        }
      ];
    };

    tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "both";
      authKeyFile = config.age.secrets.tailscale.path;

      extraUpFlags = [
        "--login-server=http://localhost:3442"
        "--advertise-exit-node=true"
        "--advertise-routes=0.0.0.0/0,::/0"
      ];
    };

    caddy = {
      enable = true;

      domains = {
        "kosslan.dev" = {
          reverseProxyList = [
            # Forgejo
            {
              subdomain = "git";
              address = cerebrite;
              port = 4000;
            }

            # Matrix
            {
              subdomain = "matrix";
              extraConfig = ''
                reverse_proxy /_matrix/* ${cerebrite}:8008
                reverse_proxy /_synapse/client/* ${cerebrite}:8008
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
            # Headscale
            {
              address = localhost;
              port = 3442;
            }
            # Jellyfin
            {
              subdomain = "jellyfin";
              address = cerebrite;
              port = 8096;
            }

            # Jellyseer
            {
              subdomain = "seer";
              address = cerebrite;
              port = 5055;
            }

            # Portainer
            {
              subdomain = "portainer";
              address = cerebrite;
              port = 9000;
            }
          ];
        };
      };
    };
  };

  routing.services = [
    # Git SSH Server
    {
      interface = interface;
      proto = "tcp";
      dport = "22";
      ipAddress = cerebrite;
    }

    # Syncthing
    {
      interface = interface;
      proto = "tcp";
      dport = "22000";
      ipAddress = cerebrite;
    }
    {
      interface = interface;
      proto = "udp";
      dport = "21027";
      ipAddress = cerebrite;
    }

    # Garry's Mod Server
    {
      interface = interface;
      proto = "udp";
      dport = "27005";
      ipAddress = cerebrite;
    }
    {
      interface = interface;
      proto = "tcp";
      dport = "27015";
      ipAddress = cerebrite;
    }
    {
      interface = interface;
      proto = "udp";
      dport = "27015";
      ipAddress = cerebrite;
    }

    # Palworld server.
    {
      interface = interface;
      proto = "udp";
      dport = "8211";
      ipAddress = cerebrite;
    }
    {
      interface = interface;
      proto = "udp";
      dport = "27016";
      ipAddress = cerebrite;
    }

    # Minecraft server.
    {
      interface = interface;
      proto = "tcp";
      dport = "25565";
      ipAddress = cerebrite;
    }
    {
      interface = interface;
      proto = "udp";
      dport = "24454";
      ipAddress = cerebrite;
    }
  ];

  networking = {
    firewall.allowedTCPPorts = [80 443];

    nameservers = ["1.1.1.1" "8.8.8.8"];
  };
}
