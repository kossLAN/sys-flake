{pkgs, ...}: {
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  graphics.amd.enable = true;

  services = {
    ssh.enable = true;
    common.enable = true;
    syncthing.enable = true;
    blueman.enable = true;

    # openvpn.servers.ipmi.config = '' config /home/koss/Downloads/TN-3003.conf '';

    mysql = {
      enable = true;
      package = pkgs.mysql80;
    };

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    printing = {
      enable = true;
      drivers = [pkgs.hplipWithPlugin];
    };
  };
}
