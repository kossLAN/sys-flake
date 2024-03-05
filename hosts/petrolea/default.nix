{pkgs, ...}: {
  imports = [
    ./services
    ./containers
    ./programs
    ./networking
    ./hardware
    ./secrets
  ];

  networking.hostName = "petrolea";
  nixpkgs.hostPlatform = "x86_64-linux";
  boot.loader.systemd-boot.enable = true;

  system = {
    defaults.enable = true;
    stateVersion = "25.05";
  };
}
