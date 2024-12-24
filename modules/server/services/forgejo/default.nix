{
  lib,
  config,
  pkgs,
  deployment,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.forgejo;
in {
  options.services.forgejo = {
    container = {
      enable = mkEnableOption "Forgjo custom configuration";

      externalInterface = mkOption {
        type = lib.types.str;
        default = "enp7s0";
      };
    };

    reverseProxy = {
      enable = mkEnableOption "Enable reverse proxy";
      domain = mkOption {
        type = lib.types.str;
        default = "kosslan.dev";
      };
    };
  };

  config = mkIf cfg.container.enable {
    deployment.containers.forgejo.owner = "forgejo";

    networking = {
      firewall = {
        allowedTCPPorts = [80 443 22];
      };

      nat = {
        enable = true;
        internalInterfaces = ["ve-+"];
        externalInterface = cfg.container.externalInterface;
      };
    };

    containers.forgejo = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = deployment.containerHostIp "forgejo";
      forwardPorts = [
        {
          containerPort = 2000;
          hostPort = 22;
          protocol = "tcp";
        }
        {
          containerPort = 4000;
          hostPort = 4000;
          protocol = "tcp";
        }
      ];

      config = {
        environment.systemPackages = [pkgs.forgejo];

        networking = {
          firewall = {
            enable = true;
            allowedTCPPorts = [4000 2000];
          };
        };

        services = {
          forgejo = {
            enable = true;
            settings = {
              server = {
                HTTP_ADDR = deployment.containerHostIp "forgejo";
                HTTP_PORT = 4000;
                DOMAIN = "git.${cfg.reverseProxy.domain}";
                ROOT_URL = "https://git.${cfg.reverseProxy.domain}/";

                START_SSH_SERVER = true;
                BUILTIN_SSH_SERVER_USER = "git";
                SSH_LISTEN_HOST = deployment.containerHostIp "forgejo";
                SSH_LISTEN_PORT = 2000;
              };

              service.DISABLE_REGISTRATION = true;
              database.SQLITE_JOURNAL_MODE = "WAL";

              cache = {
                ADAPTER = "twoqueue";
                HOST = ''{"size":100, "recent_ratio":0.25, "ghost_ratio":0.5}'';
              };

              DEFAULT.APP_NAME = "Forgejo";
              repository.DEFAULT_BRANCH = "master";
              ui.DEFAULT_THEME = "forgejo-dark";

              "ui.meta" = {
                AUTHOR = "Forgejo";
                DESCRIPTION = "kossLAN's self-hosted git instance";
              };

              metrics.ENABLED = true;
            };
          };
        };

        system.stateVersion = "23.11";
      };
    };

    services = {
      caddy = mkIf cfg.reverseProxy.enable {
        enable = true;
        virtualHosts."git.${cfg.reverseProxy.domain}".extraConfig = ''
          reverse_proxy http://${deployment.containerHostIp "forgejo"}:4000
        '';
      };
    };
  };
}
