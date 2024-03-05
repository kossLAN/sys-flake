{config, ...}: {
  jovian = {
    decky-loader.enable = true;
    hardware.has.amd.gpu = true;

    devices.steamdeck = {
      enable = true;
      autoUpdate = true;
    };

    steam = {
      enable = true;
      autoStart = true;
      desktopSession = "plasma";
      user = config.users.defaultUser;
    };
  };

  services = {
    ssh.enable = true;
    syncthing.enable = true;
    desktopManager.plasma6.enable = true;

    tailscale = {
      enable = true;
      useRoutingFeatures = "client";
    };

    xserver = {
      enable = true;
    };
  };
}
