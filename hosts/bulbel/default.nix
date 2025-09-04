{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware.nix
    inputs.nixos-hardware.nixosModules.framework-13-7040-amd
  ];

  networking.hostName = "bulbel";
  nixpkgs.hostPlatform = "x86_64-linux";

  environment = {
    systemPackages = with pkgs; [
      libreoffice-qt # Shitty office suite for linux
      prismlauncher # Minecraft Launcher
      gimp # image editing
      freecad-wayland # open source cad
      bluejay # bluetooth manager
      orca-slicer # 3d printing slicer
      plexamp # Media Player
    ];
  };

  programs = {
    firefox.enable = true;
    java.enable = true;
    obs-studio.enable = true;
    steam.enable = true;

    hyprland = {
      enable = true;
      settings = {
        xwayland.force_zero_scaling = false;
        monitor = [
          "desc:BOE NE135A1M-NY1,2880x1920@120,0x0,2.0"
          "desc:LG Electronics LG ULTRAGEAR+ 405NTPC5M160,preferred,auto-left,1.25"
          ",preferred,auto-left,1.0"
        ];
      };
    };
  };

  hardware = {
    amdgpu.enable = true;
    mobile.enable = true;
    framework.enableKmod = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services = {
    fwupd.enable = true;
    syncthing.enable = true;

    mysql = {
      enable = true;
      package = pkgs.mysql80;
    };

    printing = {
      enable = true;
      drivers = [pkgs.hplipWithPlugin];
    };
  };

  system.stateVersion = "23.11";
}
