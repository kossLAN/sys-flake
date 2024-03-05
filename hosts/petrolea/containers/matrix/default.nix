{
  lib,
  config,
  pkgs,
  deployment,
  ...
}: {
  deployment.containers.br0 = [{name = "matrix";}];

  containers.matrix = deployment.mkContainer {
    hostBridge = "br0";
    hostAddress = deployment.containerHostIp "br0";
    localAddress = "${deployment.containerLocalIp "br0" "matrix"}/24";

    bindMounts = {
      "${config.age.secrets.matrix.path}".isReadOnly = true;

      "/var/lib/matrix-synapse" = {
        isReadOnly = false;
        hostPath = "/var/lib/nixos-mounts/matrix/matrix-synapse";
      };

      "/var/lib/postgresql" = {
        isReadOnly = false;
        hostPath = "/var/lib/nixos-mounts/matrix/postgresql";
      };
    };

    config = {
      networking = {
        firewall.enable = false;
        useHostResolvConf = lib.mkForce false;
        nameservers = deployment.nameservers;
        defaultGateway.address = deployment.containerLocalIp "br0" "router-fa0";
      };

      services = {
        matrix-synapse = {
          enable = true;
          withJemalloc = true;

          # TODO: setup turn for voice chat
          # extraConfigFiles = ["/turn-shared-secret/synapse-config"];

          settings = {
            enable_registration = false;
            registration_shared_secret_path = config.age.secrets.matrix.path;

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
  };
}
