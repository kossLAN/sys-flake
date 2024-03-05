{
  lib,
  deployment,
  pkgs,
  ...
}: {
  deployment.containers.br0 = [{name = "forgejo";}];

  containers.forgejo = deployment.mkContainer {
    hostBridge = "br0";
    hostAddress = deployment.containerHostIp "br0";
    localAddress = "${deployment.containerLocalIp "br0" "forgejo"}/24";

    bindMounts = {
      "/var/lib/forgejo" = {
        isReadOnly = false;
        hostPath = "/var/lib/nixos-mounts/forgejo/forgejo";
      };
    };

    config = {config, ...}: {
      environment.systemPackages = [config.services.forgejo.package];

      networking = {
        firewall.enable = false;
        useHostResolvConf = lib.mkForce false;
        nameservers = deployment.nameservers;
        defaultGateway.address = deployment.containerLocalIp "br0" "router-fa0";
      };

      # Create admin user with
      # `gitea admin user create --admin --email "root@localhost" --username user_here --password pass_here
      services = {
        forgejo = {
          enable = true;
          settings = {
            DEFAULT.APP_NAME = "Forgejo";
            repository.DEFAULT_BRANCH = "master";
            ui.DEFAULT_THEME = "forgejo-dark";
            service.DISABLE_REGISTRATION = true;
            database.SQLITE_JOURNAL_MODE = "WAL";
            metrics.ENABLED = true;
            security.REVERSE_PROXY_TRUSTED_PROXIES = "${deployment.containerLocalIp "br0" "router-fa0"}";

            server = {
              HTTP_ADDR = deployment.containerLocalIp "br0" "forgejo";
              HTTP_PORT = 4000;
              DOMAIN = "git.kosslan.dev";
              ROOT_URL = "https://git.kosslan.dev/";

              START_SSH_SERVER = true;
              BUILTIN_SSH_SERVER_USER = "git";
              SSH_LISTEN_HOST = deployment.containerLocalIp "br0" "forgejo";
              SSH_LISTEN_PORT = 2000;
            };

            cache = {
              ADAPTER = "twoqueue";
              HOST = ''{"size":100, "recent_ratio":0.25, "ghost_ratio":0.5}'';
            };

            "ui.meta" = {
              AUTHOR = "Forgejo";
              DESCRIPTION = "kossLAN's self-hosted git instance";
            };
          };
        };
      };

      system.stateVersion = "25.11";
    };
  };
}
