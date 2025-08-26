{pkgs, ...}: {
  hardware = {
    mobile.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  display.amd.enable = true;

  services = {
    ssh.enable = true;
    common.enable = true;
    syncthing.enable = true;

    mysql = {
      enable = true;
      package = pkgs.mysql80;
    };

    udev = {
      enable = true;
      packages = with pkgs; [android-udev-rules];
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
