{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.theme.presets.quickshell;
in {
  options.theme.presets.quickshell = {
    enable = mkEnableOption "quickshell theme configuration";
  };

  config = mkIf cfg.enable {
    theme = let
      iconTheme = {
        name = "breeze-dark";
        # needs to be changed in BreezeDark.colors in the icons section
        package = pkgs.kdePackages.breeze-icons;
      };

      cursorTheme = let
        url = "https://github.com/ful1e5/notwaita-cursor/releases/download/v1.0.0-alpha1/Notwaita-Black.tar.xz";
        hash = "sha256-ZLr0C5exHVz6jeLg0HGV+aZQbabBqsCuXPGodk2P0S8=";
        name = "Notwaita-Black";
      in {
        enable = true;
        name = name;
        package = pkgs.runCommand "moveUp" {} ''
          mkdir -p $out/share/icons/default
          ln -s ${pkgs.fetchzip {
            inherit url hash;
          }} $out/share/icons/${name}
          cp ${pkgs.writeTextFile {
            name = "index.theme";
            destination = "/share/icons/default/index.theme";
            text = ''
              [Icon Theme]
              Name=Default
              Comment=Default Cursor Theme
              Inherits=${name}
            '';
          }}/share/icons/default/index.theme \
            $out/share/icons/default/index.theme
        '';
      };
    in {
      qt = {
        enable = true;
        writeToHome = true;
        package = pkgs.kdePackages.breeze;
        style = "breeze";
        kdeColorScheme = "BreezeDark";
        experimentalColorScheme = false;
        kdeGlobals = null;
        icons = iconTheme;
        cursor = cursorTheme;
        qt5.colors = "/home/${config.users.defaultUser}/.config/qt5ct/colors/matugen.conf";
        qt6.colors = "/home/${config.users.defaultUser}/.config/qt6ct/colors/BreezeDark.colors";
      };
    };
  };
}
