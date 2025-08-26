{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./boot
    ./hardware
    ./programs
    ./services
    ./school

    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  networking.hostName = "bulbel";
  nixpkgs.hostPlatform = "x86_64-linux";

  environment = {
    localBinInPath = true;
    enableDebugInfo = true;
  };

  system = {
    defaults.enable = true;
    stateVersion = "23.11";
  };

  hardware.framework.enableKmod = true;
  services.fwupd.enable = true;
}
