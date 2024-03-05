{...}: {
  imports = [
    ./boot
    ./hardware
    ./programs
    ./services
  ];

  networking.hostName = "galahad";
  nixpkgs.hostPlatform = "x86_64-linux";

  system = {
    defaults.enable = true;
    stateVersion = "23.11";
  };
}
