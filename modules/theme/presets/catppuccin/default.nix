{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.theme.presets.catppuccin;
in {
  options.theme.presets.catppuccin = {
    enable = mkEnableOption "Enable catppuccin preset";
  };

  config = mkIf cfg.enable {
    theme = let
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.catppuccin-papirus-folders.override {
          flavor = "mocha";
          accent = "blue";
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
        writeToHome = true;
        package = pkgs.kdePackages.breeze;
        style = "Breeze";
        kdeColorScheme = "BreezeDark";
        kdeGlobals = ./kdeglobals;
        icons = iconTheme;
        cursor = cursorTheme;
        qt5.colors = ./colors-qt5.conf;
        qt6.colors = ./colors-qt6.conf;
      };

      gtk = {
        enable = true;
        name = "catppuccin-macchiato-blue-compact";
        icons = iconTheme;
        cursor = cursorTheme;
        package = pkgs.catppuccin-gtk.override {
          accents = ["blue"];
          size = "compact";
          variant = "macchiato";
        };
      };
    };
  };
}
