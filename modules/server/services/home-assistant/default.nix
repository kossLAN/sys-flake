{
  lib,
  config,
  deployment,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.home-assistant.container;
  externalInterface = "enp7s0";
in {
  options.services.home-assistant.container = {
    enable = mkEnableOption "Enable the Home-Assistant Container";
  };

  config = mkIf cfg.enable {
    deployment.containers.home-assistant.owner = "home-assistant";

    networking = {
      # firewall.allowedTCPPorts = [8008];

      nat = {
        enable = true;
        internalInterfaces = ["ve-+"];
        externalInterface = externalInterface;
      };
    };

    containers.home-assistant = {
      autoStart = true;
      privateNetwork = true;
      hostAddress = "192.168.100.10";
      localAddress = deployment.containerHostIp "home-assistant";

      config = {
        networking = {
          firewall.allowedTCPPorts = [8123];
          useHostResolvConf = lib.mkForce false;
        };

        services = {
          resolved.enable = true;

          home-assistant = {
            enable = true;

            config = {
              http = {
                use_x_forwarded_for = true;
                trusted_proxies = ["192.168.100.10"];
                server_port = 8123;
                server_host = [
                  "0.0.0.0"
                  "::"
                ];
              };
            };
          };
        };

        system.stateVersion = "24.11";
      };
    };
  };
}
