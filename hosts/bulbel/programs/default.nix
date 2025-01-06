{
  pkgs,
  inputs,
  config,
  ...
}: {
  environment = {
    systemPackages = with pkgs; [
      mpv
      keepassxc
      bambu-studio
      libreoffice-qt
      prismlauncher
      vesktop

      inputs.agenix.packages.${pkgs.stdenv.system}.default
    ];

    variables = {
      "STEAM_FORCE_DESKTOPUI_SCALING" = "2.0";
    };
  };

  programs = {
    zen-browser.enable = true;
    partition-manager.enable = true;
    common.enable = true;
    java.enable = true;
    git.enable = true;
    obs-studio.enable = true;
    foot.enable = true;
    steam.enable = true;

    hyprland = {
      enable = true;
      extraConf = ''
        monitor = DP-8,3840x2160@120,auto,1.25
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
