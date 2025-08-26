{inputs, ...}: {
  imports = [
    ./hardware
    ./boot
    ./programs
    ./services
    ./networking

    inputs.jovian.nixosModules.jovian
  ];

  networking.hostName = "compass";

  nixpkgs.hostPlatform = "x86_64-linux";

  environment = {
    localBinInPath = true;
    enableDebugInfo = true;
  };

  system = {
    defaults.enable = true;
    stateVersion = "24.11";
  };
}
