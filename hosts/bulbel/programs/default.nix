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
      extraConf = ''
        # Monitor Configuration
        monitor=eDP-1,2880x1920@120,auto,2.0
        monitor=DP-7,3840x2160@240,0x0,1.25
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
