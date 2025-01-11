{
  config,
  lib,
  ...
}: let
  inherit (lib.types) str int package;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.theme.gtk;
in {
  options.theme.gtk = {
    enable = mkEnableOption "Enable GTK Theming";

    package = mkOption {
      type = package;
    };

    name = mkOption {
      type = str;
    };

    icons = {
      name = mkOption {
        type = str;
      };

      package = mkOption {
        type = package;
      };
    };

    cursor = {
      enable = mkEnableOption "Cursor theme";

      package = mkOption {
        type = package;
      };

      name = mkOption {
        type = str;
        description = "Name of the theme package";
      };

      cursorSize = mkOption {
        type = int;
        default = 24;
      };
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = let
        basePackages = [
          cfg.package
        ];

        cursorPackages = lib.optionals cfg.cursor.enable [
          cfg.cursor.package
        ];
      in
        basePackages ++ cursorPackages;

      sessionVariables = {
        GTK_THEME = cfg.name;
      };

      etc = let
        gtkSettings = ''
          [Settings]
          gtk-cursor-theme-name=${cfg.cursor.name}
          gtk-cursor-theme-size=${toString cfg.cursor.cursorSize}
        '';
      in
        mkIf cfg.cursor.enable {
          "xdg/gtk-3.0/settings.ini" = {
            text = gtkSettings;
            mode = "444";
          };

          "xdg/gtk-4.0/settings.ini" = {
            text = gtkSettings;
            mode = "444";
          };
        };
    };

    programs.dconf = {
      enable = true;
      profiles.user.databases = [
        {
          lockAll = true; # prevents overriding
          settings = {
            "org/gnome/desktop/interface" = {
              gtk-theme = cfg.name;
              icon-theme = cfg.icons.name;
              cursor-theme = "'${cfg.cursor.name}'";
              cursor-size = lib.gvariant.mkUint16 cfg.cursor.cursorSize;
            };
          };
        }
      ];
    };
  };
}
