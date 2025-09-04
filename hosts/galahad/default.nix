{pkgs, ...}: {
  imports = [./hardware.nix];

  networking.hostName = "galahad";
  nixpkgs.hostPlatform = "x86_64-linux";

  environment.systemPackages = with pkgs; [
    orca-slicer # 3d printing slicer
    libreoffice-qt # office suite - it sucks
    blender-hip # amd focused blender
    gimp3 # photo editor
    prismlauncher # minecraft launcher
    freecad-wayland # open source cad
    eddie # air vpn client
    via # keyboard software
    plexamp # Media Player
  ];

  programs = {
    corectrl.enable = true;
    java.enable = true;
    obs-studio.enable = true;
    firefox.enable = true;
    steam.enable = true;

    hyprland = {
      enable = true;
      settings.monitor = [
        "desc:LG Electronics LG ULTRAGEAR+ 405NTPC5M160,preferred,0x0,1.25"
        "desc:HP Inc. OMEN X 27 CNK10336W9,preferred,auto-left,1.0"
      ];
    };
  };

  hardware = {
    amdgpu.enable = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
  };

  services = {
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
