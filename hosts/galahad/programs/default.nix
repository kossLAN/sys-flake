{
  pkgs,
  config,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    mpv # media player
    via # keyboard configurator
    keepassxc # password manager
    bambu-studio # bambu slicer for 3d printing
    libreoffice-qt # office suite - it sucks
    blender-hip # this is broken
    gimp # photo editor
    prismlauncher # minecraft launcher

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
      extraConf = ''
        monitor = DP-2,3840x2160@240,auto,1.25
      '';
    };

    nh = {
      enable = true;
      flake = "/home/${config.users.defaultUser}/.nixos-conf";
    };

    custom-neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
