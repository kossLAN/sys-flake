{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.theme.presets.breeze;
in {
  options.theme.presets.breeze = {
    enable = mkEnableOption "Enable Breeze QT theme";
  };

  config = mkIf cfg.enable {
    theme = let
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "teal";
        };
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
        style = "Breeze";
        kdeColorScheme = "BreezeDark";
        kdeGlobals = ./kdeglobals;
        writeToHome = true;
        icons = iconTheme;
        cursor = cursorTheme;

        qt5 = {
          package = pkgs.libsForQt5.breeze-qt5;
          colors = ./colors-qt5.conf;
        };

        qt6 = {
          package = pkgs.kdePackages.breeze;
          colors = ./colors-qt6.conf;
        };
      };

      gtk = {
        enable = true;
        package = pkgs.kdePackages.breeze-gtk;
        name = "Breeze-Dark";
        icons = iconTheme;
        cursor = cursorTheme;
      };
    };
  };
}
