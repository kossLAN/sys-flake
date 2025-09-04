{
  config,
  pkgs,
  ...
}: {
  environment.systemPackages = [pkgs.sshfs];
  programs.ssh.startAgent = true;

  users.users.${config.users.defaultUser} = {
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINOQiiDrsm38BvJ+UfdryrYMfUM2GG7S7gps81sSkrjL"
    ];
  };

  services.openssh = {
    enable = true;
    openFirewall = true;
    allowSFTP = true;

    settings = {
      PermitRootLogin = "prohibit-password";
      PasswordAuthentication = false;
      UsePAM = true;
    };
  };
}
