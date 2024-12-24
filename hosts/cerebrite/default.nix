{...}: {
  imports = [
    ./services
    ./programs
    ./networking
    ./hardware
    ./arr
    ./secrets
  ];

  boot.loader = {
    systemd-boot.enable = true;
    efi.canTouchEfiVariables = true;
  };

  networking.hostName = "cerebrite";
  nixpkgs.hostPlatform = "x86_64-linux";

  services.xserver.videoDrivers = ["nvidia"];

  hardware = {
    graphics.enable = true;
    nvidia = {
      modesetting.enable = true;
      open = false;
    };
  };

  system = {
    defaults.enable = true;
    stateVersion = "24.05";
  };
}
