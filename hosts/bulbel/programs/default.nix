{
  pkgs,
  inputs,
  config,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      vlc # Media Player
      keepassxc # Password Manager
      libreoffice-qt # Shitty office suite for linux
      prismlauncher # Minecraft Launcher
      gimp # image editing
      freecad-wayland # open source cad
      bluejay # bluetooth manager
      orca-slicer # 3d printing slicer
      plexamp # Media Player

      inputs.agenix.packages.${pkgs.stdenv.system}.default
    ];
  };

  programs = {
    firefox.enable = true;
    common.enable = true;
    java.enable = true;
    git.enable = true;
    obs-studio.enable = true;
    foot.enable = true;
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
