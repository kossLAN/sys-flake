{
  pkgs,
  config,
  inputs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vesktop # discord client
    mpv # media player
    via # keyboard configurator
    keepassxc # password manager
    bambu-studio # bambu slicer for 3d printing
    wootility # wooting keyboard tool
    libreoffice-qt # office suite - it sucks
    blender-hip # this is broken
    gimp # photo editor
    jellyfin-media-player # firefox can't play h265 :(
    osu-lazer-bin # shit game
    prismlauncher # minecraft launcher

    inputs.agenix.packages.${pkgs.stdenv.system}.default
  ];

  programs = {
    partition-manager.enable = true;
    corectrl.enable = true;
    common.enable = true;
    git.enable = true;
    java.enable = true;
    obs-studio.enable = true;
    zen-browser.enable = true;
    steam.enable = true;
    foot.enable = true;

    hyprland = {
      enable = true;
      monitors = [
        "DP-2,3840x2160@240,auto,1.25"
      ];
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
