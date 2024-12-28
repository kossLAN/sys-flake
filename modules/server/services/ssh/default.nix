{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.ssh;
  sshPort = 1000;
in {
  options.services.ssh = {
    enable = mkEnableOption "ssh";
  };

  config = mkIf cfg.enable {
    users.users.root.openssh.authorizedKeys.keys = [
      ''
        ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpkeLOreGeqUDLcrlYgzyeSSZmBvJLY+dWOeORIpGQQVRvlko8NRcVKS/fa5EHBd9HG9gRs96FK5WF9JJCGsY4ovL++WZwlsQN3xfc0xq2Sn8TQhgDgiBFCR05JDMi1+f6v9WpaiLiQnOKiTmSGYhzvayIr/XrpcAaXo0mLDEnqZbSzqTcAcqZMcPZixmkgFJA+kUq6d1Z5XMPRRTPJNmLGY0jNbVlUiI9pWsIlGqZFcMLssNWnIZkl8SCV/lN+uyFy2G1o1LlMQ6UFziqP3Zm28gq6alt7ivFJ8A8hUffiZWeQ4uURV8TKhQ43FGSUspma7DpG5zGdionkN521rQJajdnWJLO25dXRkDdXWmkwpFuKRep0m0xv0VSxXAPYs5IrFuDuylbfo6W0N5dx2sPgBK8cQ2uj5AvVCM6g8cgWh+pxzG/WV/2XpwrT7jD8vyRUL+U6FpiMQIsepJ/WQIhA7HkQnex2QHGAsu7hP5Wr5Bs33m8JYT5XCT0KsXkzQE=
      ''
    ];

    networking = {
      firewall = {
        allowedTCPPorts = [sshPort];
      };
    };

    services = {
      openssh = {
        enable = true;
        allowSFTP = true;
        ports = [sshPort];

        listenAddresses = [
          {
            addr = "0.0.0.0";
            port = sshPort;
          }
        ];

        settings = {
          PermitRootLogin = "prohibit-password";
          PasswordAuthentication = false;
          LogLevel = "VERBOSE";
        };
      };

      fail2ban = {
        enable = true;
        bantime = "10m";
        maxretry = 8;

        bantime-increment = {
          enable = true;
          rndtime = "10m";
          maxtime = "48h";
        };

        ignoreIP = [
          "192.168.1.0/20"
          "100.64.0.0/20"
        ];
      };
    };
  };
}
