{
  pkgs,
  config,
  inputs,
  lib,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vlc # media player
    keepassxc # password manager
    orca-slicer # 3d printing slicer
    libreoffice-qt # office suite - it sucks
    blender-hip # amd focused blender
    gimp3 # photo editor
    prismlauncher # minecraft launcher
    freecad-wayland # open source cad
    eddie # air vpn client
    via # keyboard software
    plexamp # Media Player

    inputs.agenix.packages.${pkgs.stdenv.system}.default
  ];

  programs = {
    corectrl.enable = true;
    common.enable = true;
    git.enable = true;
    java.enable = true;
    obs-studio.enable = true;
    firefox.enable = true;
    steam.enable = true;
    foot.enable = true;

    hyprland = {
      enable = true;
      settings = {
        monitor = [
          "desc:LG Electronics LG ULTRAGEAR+ 405NTPC5M160,preferred,0x0,1.25"
          "desc:HP Inc. OMEN X 27 CNK10336W9,preferred,auto-right,1.0"
        ];
      };
    };

    nh = {
      enable = true;
      flake = "/home/${config.users.defaultUser}/.nixos-conf";
    };

    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
