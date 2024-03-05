{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.kdesuite;
in {
  options.programs.kdesuite = {
    enable = mkEnableOption "Enable KDE Suite of basic programs";
  };

  # NOTE: this shit is ass, and kde/nix should feel bad for this being the way this is done lol....
  config = mkIf cfg.enable {
    users.users.${config.users.defaultUser}.file = {
      # taken from plasma-workspace. required for dolphin to be able to open any files.
      ".config/menus/applications.menu".source = ./plasma-applications.menu;
    };

    environment.systemPackages = with pkgs;
      [
        libssh
      ]
      ++ (with pkgs.kdePackages; [
        dolphin
        dolphin-plugins
        gwenview
        ark
        kdenlive

        # open with
        kservice
        kde-cli-tools

        # thumbnails
        ffmpegthumbs
        kio
        kio-extras
        kio-fuse
        kimageformats
        kdegraphics-thumbnailers
      ]);

    programs = {
      partition-manager.enable = true;
      kdeconnect = {
        enable = true;
        package = pkgs.kdePackages.kdeconnect-kde;
      };
    };
  };
}
