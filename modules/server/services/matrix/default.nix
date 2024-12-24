{
  lib,
  pkgs,
  config,
  deployment,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.services.matrix.container;
in {
  options.services.matrix.container = {
    enable = mkEnableOption "Matrix container";

    secretPath = mkOption {
      type = lib.types.path;
      default = config.age.secrets.matrix.path;
    };
  };

  config = let
    externalInterface = "enp7s0";
  in
    mkIf cfg.enable {
      deployment.containers.matrix.owner = "matrix";

      networking = {
        firewall.allowedTCPPorts = [8008];

        nat = {
          enable = true;
          internalInterfaces = ["ve-+"];
          externalInterface = externalInterface;
        };
      };

      containers.matrix = {
        autoStart = true;
        privateNetwork = true;
        hostAddress = "192.168.100.10";
        localAddress = deployment.containerHostIp "matrix";
        forwardPorts = [
          {
            containerPort = 8008;
            hostPort = 8008;
            protocol = "tcp";
          }
        ];

        config = {
          networking = {
            firewall.allowedTCPPorts = [8008];
            useHostResolvConf = lib.mkForce false;
          };

          services = {
            resolved.enable = true;

            matrix-synapse = {
              enable = true;
              withJemalloc = true;

              # TODO: setup turn for voice chat
              # extraConfigFiles = ["/turn-shared-secret/synapse-config"];

              settings = {
                enable_registration = false;
                registration_shared_secret_path = cfg.secretPath;

                server_name = "kosslan.dev";
                dynamic_thumbnails = true;
                max_upload_size = "200M";

                # turn_uris = let
                #   addr = "turn.kosslan.dev";
                # in [
                #   "turn:${addr}?transport=udp"
                #   "turn:${addr}?transport=tcp"
                # ];
                #
                # turn_user_lifetime = "1h";
                # turn_allow_guests = true;

                listeners = [
                  {
                    port = 8008;
                    bind_addresses = ["0.0.0.0"];
                    type = "http";
                    tls = false;
                    x_forwarded = true;

                    resources = [
                      {
                        names = ["client" "federation"];
                        compress = true;
                      }
                    ];
                  }
                ];
              };
            };

            postgresql = {
              enable = true;
              enableJIT = true;

              initialScript = pkgs.writeText "synapse-init.sql" ''
                CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
                CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
                  TEMPLATE template0
                  ENCODING 'UTF8'
                  LC_COLLATE = "C"
                  LC_CTYPE = "C";
              '';
            };
          };

          system.stateVersion = "23.11";
        };

        bindMounts = {
          "${cfg.secretPath}" = {isReadOnly = true;};
        };
      };
    };
}
