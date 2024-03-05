{config, ...}: {
  services = {
    ssh.enable = true;

    sanoid = {
      enable = true;

      datasets."rpool/nixos-mounts" = {
        hourly = 2;
      };
    };
  };
}
