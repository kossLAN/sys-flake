{
  lib,
  deployment,
  config,
  ...
}: {
  deployment.containers.br0 = [{name = "deluge";}];
  systemd.tmpfiles.rules = ["d /srv/torrents - 1000 1000 - -"];

  containers.deluge = deployment.mkContainer {
    enableTun = true;
    hostBridge = "br0";
    hostAddress = deployment.containerHostIp "br0";
    localAddress = "${deployment.containerLocalIp "br0" "deluge"}/24";

    bindMounts = {
      "${config.age.secrets.openvpn-newyork.path}" = {isReadOnly = true;};
      "/srv/torrents".isReadOnly = false;
    };

    config = {pkgs, ...}: {
      networking = {
        firewall.enable = false;
        useHostResolvConf = lib.mkForce false;
        defaultGateway.address = deployment.containerLocalIp "br0" "router-fa0";
        nameservers = deployment.nameservers;
      };

      users = {
        users.deluge = {
          uid = lib.mkForce 1000;
          isSystemUser = true;
        };

        groups.deluge.gid = lib.mkForce 1000;
      };

      services = {
        resolved.enable = true;

        openvpn.servers = {
          openvpn-newyork = {
            config = "config ${config.age.secrets.openvpn-newyork.path}";
          };
        };

        deluge = {
          enable = true;
          authFile = pkgs.writeText "deluge-auth" "localclient:deluge:10";
          declarative = true;

          web = {
            enable = true;
            port = 8112;
          };

          config = {
            download_location = "/srv/torrents/";
            # max_upload_speed = "40960";
            # max_download_speed = "40960";
            # share_ratio_limit = 4;
            # stop_seed_ratio = 4;
            # stop_seed_at_ratio = true;
            max_active_seeding = 40;
            max_active_downloading = 8;
            max_active_limit = 48;
            seed_time_limit = "25000";
            allow_remote = true;
            listen_interface = "10.73.150.20";
            random_port = false;
            daemon_port = 58846;
            listen_ports = [8284 8284];
            enabled_plugins = ["Label"];
            upnp = true;
            natpmp = false;
            lsd = false;
            dht = true;
          };
        };
      };

      system.stateVersion = "24.05";
    };
  };
}
