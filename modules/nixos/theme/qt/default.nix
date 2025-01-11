{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.types) path str int bool package;
  inherit (lib.modules) mkIf mkForce;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.theme.qt;
in {
  # Designed with qtct only in mind, if you use anything perish.
  # TODO: Add descriptions
  options.theme.qt = {
    enable = mkEnableOption "Enable QT Theming";

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

    qt5 = {
      package = mkOption {
        type = package;
        default = pkgs.libsForQt5.breeze-qt5;
      };

      colors = mkOption {
        type = path;
      };
    };

    qt6 = {
      package = mkOption {
        type = package;
        default = pkgs.kdePackages.breeze;
      };

      colors = mkOption {
        type = path;
      };
    };

    kdeGlobals = mkOption {
      type = path;
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
    # TODO: I should convert to this to attrset to expand nix modularity
    qtConf = colors: ''
      [Appearance]
      style=${cfg.style}
      icon_theme=${cfg.icons.name}
      standard_dialogs=xdgdesktopportal

      color_scheme_path=${colors}
      custom_palette=true

      [Fonts]
      fixed="DejaVu Sans,10,-1,5,50,0,0,0,0,0,Condensed"
      general="DejaVu Sans,10,-1,5,50,0,0,0,0,0,Condensed"

      [Interface]
      buttonbox_layout=0
      cursor_flash_time=1000
      dialog_buttons_have_icons=2
      double_click_interval=400
      gui_effects=General, AnimateMenu, AnimateCombo
      keyboard_scheme=2
      menus_have_icons=true
      show_shortcuts_in_context_menus=true
      toolbutton_style=4
      underline_shortcut=1
      wheel_scroll_lines=3
    '';
  in
    mkIf cfg.enable {
      environment = {
        systemPackages = let
          basePackages = [
            cfg.qt5.package
            cfg.qt6.package
            cfg.icons.package
          ];

          cursorPackages = lib.optionals cfg.cursor.enable [
            cfg.cursor.package
          ];
        in
          basePackages ++ cursorPackages;

        variables = mkIf cfg.cursor.enable {
          XCURSOR_SIZE = mkForce cfg.cursor.cursorSize;
          XCURSOR_THEME = mkForce cfg.cursor.name;
          XCURSOR_PATH = mkForce [
            "${cfg.cursor.package}/share/icons"
          ];
        };

        etc = mkIf (!cfg.writeToHome) {
          "xdg/kdeglobals".source = cfg.kdeGlobals;
          "xdg/qt5ct/qt5ct.conf".text = qtConf cfg.qt5.colors;
          "xdg/qt6ct/qt6ct.conf".text = qtConf cfg.qt6.colors;
        };
      };

      users.users.${config.users.defaultUser}.file = mkIf cfg.writeToHome {
        ".config/kdeglobals".source = cfg.kdeGlobals;
        ".config/qt5ct/qt5ct.conf".text = qtConf cfg.qt5.colors;
        ".config/qt6ct/qt6ct.conf".text = qtConf cfg.qt6.colors;
      };

      qt = {
        enable = true;
        platformTheme = "qt5ct";
      };
    };
}
