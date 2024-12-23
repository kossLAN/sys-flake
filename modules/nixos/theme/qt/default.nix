{
  config,
  lib,
  ...
}: let
  inherit (lib.types) path str package;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.theme.qt;
in {
  imports = [
    ./breeze
    ./catppuccin
  ];

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

    qt5 = {
      package = mkOption {
        type = package;
      };

      colors = mkOption {
        type = path;
      };
    };

    qt6 = {
      package = mkOption {
        type = package;
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
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [cfg.qt5.package cfg.qt6.package cfg.icons.package];

      etc = let
        # TODO: make this an attrset and then convert to this file for more module configuration
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
      in {
        # TODO: Modulize
        "xdg/kdeglobals".source = cfg.kdeGlobals;
        "xdg/qt5ct/qt5ct.conf".text = qtConf cfg.qt5.colors;
        "xdg/qt6ct/qt6ct.conf".text = qtConf cfg.qt6.colors;
      };
    };

    qt = {
      enable = true;
      platformTheme = "qt5ct";
    };
  };
}
