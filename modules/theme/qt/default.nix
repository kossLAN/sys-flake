{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.types) nullOr path str int bool package;
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.theme.qt;
in {
  options.theme.qt = {
    enable = mkEnableOption "Enable QT Theming";
    package = mkOption {
      type = package;
      default = pkgs.kdePackages.breeze;
    };

    style = mkOption {
      type = str;
    };

    kdeColorScheme = mkOption {
      type = str;
    };

    writeToHome = mkOption {
      type = bool;
      default = false;
      description = ''
        Whether to use a home-management solution to write to home,
        instead of using xdg config files...
      '';
    };

    experimentalColorScheme = mkOption {
      type = bool;
      default = true;
    };

    qt5 = {
      colors = mkOption {
        type = path;
      };
    };

    qt6 = {
      colors = mkOption {
        type = path;
      };
    };

    kdeGlobals = mkOption {
      type = nullOr path;
      default = "${cfg.qt6.package}/share/color-schemes/${cfg.kdeColorScheme}.colors";
    };

    icons = {
      name = mkOption {
        type = str;
        description = "Icon theme to use for QT applications.";
      };

      package = mkOption {
        type = package;
        description = "Package to install for the icon theme.";
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

  config = let
    qtConf = qt6: kdeColors: ''
      [Appearance]
      style=${cfg.style}
      icon_theme=${cfg.icons.name}
      standard_dialogs=xdgdesktopportal
      custom_palette=true
      ${
        if kdeColors
        then ''
          color_scheme_path=${cfg.kdeGlobals}
        ''
        else ''
          color_scheme_path=${
            if qt6
            then cfg.qt6.colors
            else cfg.qt5.colors
          }
        ''
      }

      [Fonts]
      fixed="DejaVu Sans,10,-1,5,50,0,0,0,0,0,Condensed"
      general="DejaVu Sans,10,-1,5,50,0,0,0,0,0,Condensed"

      [Interface]
      activate_item_on_single_click=1
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=2
      double_click_interval=400
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      toolbutton_style=2
      underline_shortcut=1
      wheel_scroll_lines=3

      [Troubleshooting]
      force_raster_widgets=0
    '';
  in
    mkIf cfg.enable {
      environment = {
        systemPackages =
          [
            cfg.package
            # cfg.icons.package

            pkgs.kdePackages.qqc2-desktop-style
            pkgs.kdePackages.kirigami
            pkgs.kdePackages.kirigami.unwrapped
            pkgs.kdePackages.kirigami-addons
            pkgs.kdePackages.sonnet
          ]
          ++ lib.optionals cfg.cursor.enable [
            cfg.cursor.package
          ];

        variables = mkIf cfg.cursor.enable {
          XCURSOR_SIZE = mkForce cfg.cursor.cursorSize;
          XCURSOR_THEME = mkForce cfg.cursor.name;
          XCURSOR_PATH = mkForce [
            "${cfg.cursor.package}/share/icons"
          ];
        };

        # etc = mkIf (!cfg.writeToHome) {
        #   "xdg/kdeglobals".source = mkIf (cfg.kdeGlobals != null) (cfg.kdeGlobals);
        #   "xdg/qt5ct/qt5ct.conf".text = qtConf false false;
        #   "xdg/qt6ct/qt6ct.conf".text = qtConf true cfg.experimentalColorScheme;
        # };
      };

      users.users.${config.users.defaultUser}.file = mkIf cfg.writeToHome {
        ".config/qt5ct/qt5ct.conf".text = qtConf false false;
        ".config/qt6ct/qt6ct.conf".text = qtConf true cfg.experimentalColorScheme;
      };

      qt = {
        enable = true;
        platformTheme = "qt5ct";
        style = "breeze"; # NOTE: think this is causing issues, installing the qt5 version of breeze theme
      };

      nixpkgs.overlays = [
        (final: prev: {
          qt6Packages = prev.qt6Packages.overrideScope (qfinal: qprev: {
            qt6ct = qprev.qt6ct.overrideAttrs (ctprev: {
              src = pkgs.fetchFromGitLab {
                domain = "www.opencode.net";
                owner = "ilya-fedin";
                repo = "qt6ct";
                rev = "6fa66ca94f1f8fa5119ad6669d5e3547f4077c1c"; # 'kde' branch
                sha256 = "z84z4XhAVqIJpF3m6H9FwFiDR7Nk+AY2tLpsibNEzPY=";
              };

              buildInputs =
                ctprev.buildInputs
                ++ (with final.kdePackages; [
                  kconfig
                  kcolorscheme
                  kiconthemes
                ]);
            });
          });
        })
      ];
    };
}
