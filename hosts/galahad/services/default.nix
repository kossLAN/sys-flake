{pkgs, ...}: {
  hardware = {
    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  display.amd.enable = true;

  virtualisation.docker = {
    enable = true;
  };

  # docker api
  networking.firewall.allowedTCPPorts = [2375];

  services = {
    ssh.enable = true;
    common.enable = true;
    syncthing.enable = true;
    blueman.enable = true;
    udevRules.keyboard.enable = true;
    
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
