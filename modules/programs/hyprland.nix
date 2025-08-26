{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) str path;

  cfg = config.programs.hyprland;

  toHyprconf = {
    attrs,
    indentLevel ? 0,
    importantPrefixes ? ["$"],
  }: let
    inherit
      (lib)
      all
      concatMapStringsSep
      concatStrings
      concatStringsSep
      filterAttrs
      foldl
      generators
      hasPrefix
      isAttrs
      isList
      mapAttrsToList
      replicate
      ;

    initialIndent = concatStrings (replicate indentLevel "  ");

    toHyprconf' = indent: attrs: let
      sections =
        filterAttrs (n: v: isAttrs v || (isList v && all isAttrs v)) attrs;

      mkSection = n: attrs:
        if lib.isList attrs
        then (concatMapStringsSep "\n" (a: mkSection n a) attrs)
        else ''
          ${indent}${n} {
          ${toHyprconf' "  ${indent}" attrs}${indent}}
        '';

      mkFields = generators.toKeyValue {
        listsAsDuplicateKeys = true;
        inherit indent;
      };

      allFields =
        filterAttrs (n: v: !(isAttrs v || (isList v && all isAttrs v)))
        attrs;

      isImportantField = n: _:
        foldl (acc: prev:
          if hasPrefix prev n
          then true
          else acc)
        false
        importantPrefixes;

      importantFields = filterAttrs isImportantField allFields;

      fields =
        builtins.removeAttrs allFields
        (mapAttrsToList (n: _: n) importantFields);
    in
      mkFields importantFields
      + concatStringsSep "\n" (mapAttrsToList mkSection sections)
      + mkFields fields;
  in
    toHyprconf' initialIndent attrs;
in {
  options.programs.hyprland = {
    wallpaper = mkOption {
      type = path;
      default = ./wallpaper.jpg;
    };

    settings = mkOption {
      type = with lib.types; let
        valueType =
          nullOr (oneOf [
            bool
            int
            float
            str
            path
            (attrsOf valueType)
            (listOf valueType)
          ])
          // {
            description = "Hyprland configuration value";
          };
      in
        valueType;
      default = {};
    };

    sourceFirst =
      lib.mkEnableOption ''
        putting source entries at the top of the configuration
      ''
      // {
        default = true;
      };

    importantPrefixes = mkOption {
      type = with lib.types; listOf str;
      default =
        ["$" "bezier" "name"]
        ++ lib.optionals cfg.sourceFirst ["source"];
      example = ["$" "bezier"];
      description = ''
        List of prefix of attributes to source at the top of the config.
      '';
    };

    extraConf = mkOption {
      type = str;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    # XDG Portal Nonsense
    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;
      extraPortals = [
        # pkgs.libsForQt5.xdg-desktop-portal-kde
        pkgs.kdePackages.xdg-desktop-portal-kde
      ];

      config.hyprland = {
        default = [
          "hyprland"
          "kde"
        ];
      };
    };

    # System Apps that I will use on this shit
    environment = {
      sessionVariables = {
        NIXOS_OZONE_WL = "1";
        WLR_DRM_NO_ATOMIC = "1";
        QT_QPA_PLATFORM = "wayland";
        GDK_BACKEND = "wayland,x11";
      };

      systemPackages = with pkgs; [
        xorg.xrandr
      ];
    };

    # theme.presets.quickshell.enable = true;
    theme.presets.breeze.enable = true;

    services = {
      greetd = {
        enable = true;
        quickshell.enable = true;
      };
    };

    programs = {
      kdesuite.enable = true;
      nm-applet.enable = true;

      quickshell = {
        enable = true;
        systemd.enable = true;
      };

      hyprland = {
        xwayland.enable = true;
        settings = let
          mainMod = "SUPER";
        in {
          exec-once = [
            "${pkgs.hyprpolkitagent}/libexec/hyprpolkitagent"
            # "${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1"
            "${lib.getExe' pkgs.dbus "dbus-update-activation-environment"} --systemd --all && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target"
            "${lib.getExe pkgs.hypridle}"
            "kdeconnectd"
            "hyprctl plugin load ${pkgs.hyprlandPlugins.hyprsplit}/lib/libhyprsplit.so"
          ];

          animations = lib.mkDefault {
            enabled = lib.mkDefault true;
            bezier = lib.mkDefault [
              "linear, 0.5, 0.5, 0.5, 0.5"
              "antiEase, 0.6, 0.4, 0.6, 0.4"
              "ease, 0.4, 0.6, 0.4, 0.6"
              "smooth, 0.5, 0.9, 0.6, 0.95"
              "htooms, 0.95, 0.6, 0.9, 0.5"
              "powered, 0.5, 0.2, 0.6, 0.5"
            ];
            animation = lib.mkDefault [
              "windows, 1, 2.5, smooth"
              "windowsOut, 1, 1, htooms, popin 80%"
              "fade, 1, 5, smooth"
              "workspaces, 1, 6, default"
            ];
          };

          decoration = {
            rounding = lib.mkDefault 8;
            blur = {
              enabled = lib.mkDefault true;
              contrast = lib.mkDefault 1;
              new_optimizations = lib.mkDefault true;
              noise = lib.mkDefault 0;
              passes = lib.mkDefault 5;
              size = lib.mkDefault 8;
            };
            shadow = {
              enabled = lib.mkDefault false;
              range = lib.mkDefault 5;
            };
          };

          dwindle = {
            force_split = lib.mkDefault 2;
            preserve_split = lib.mkDefault true;
            pseudotile = lib.mkDefault true;
            smart_resizing = lib.mkDefault true;
            smart_split = lib.mkDefault false;
          };

          general = {
            allow_tearing = lib.mkDefault true;
            border_size = lib.mkDefault 1;
            "col.active_border" = lib.mkDefault "rgba(ffffff26)";
            "col.inactive_border" = lib.mkDefault "rgba(40434fff)";
            gaps_in = lib.mkDefault 3;
            gaps_out = lib.mkDefault 5;
            layout = lib.mkDefault "dwindle";
            resize_on_border = lib.mkDefault true;
          };

          input = {
            accel_profile = lib.mkDefault "flat";
            follow_mouse = lib.mkDefault 1;
            kb_layout = lib.mkDefault "us";
            kb_model = lib.mkDefault "";
            kb_options = lib.mkDefault "";
            kb_rules = lib.mkDefault "";
            kb_variant = lib.mkDefault "";
            sensitivity = lib.mkDefault 0;

            touchpad = {
              disable_while_typing = lib.mkDefault true;
              clickfinger_behavior = lib.mkDefault true;
            };
          };

          gestures = {
            workspace_swipe = lib.mkDefault true;
            workspace_swipe_invert = lib.mkDefault false;
            workspace_swipe_fingers = lib.mkDefault 3;
            workspace_swipe_distance = lib.mkDefault 200;
            workspace_swipe_min_speed_to_force = lib.mkDefault 0;
            workspace_swipe_create_new = lib.mkDefault false;
            workspace_swipe_cancel_ratio = lib.mkDefault 0.5;
            workspace_swipe_forever = lib.mkDefault true;
            workspace_swipe_direction_lock = lib.mkDefault false;
          };

          misc = {
            animate_manual_resizes = lib.mkDefault false;
            disable_hyprland_logo = lib.mkDefault true;
            disable_splash_rendering = lib.mkDefault true;
            force_default_wallpaper = lib.mkDefault 0;
            disable_autoreload = lib.mkDefault true;
            focus_on_activate = lib.mkDefault false;
            key_press_enables_dpms = lib.mkDefault true;
            mouse_move_enables_dpms = lib.mkDefault false;
            render_ahead_of_time = lib.mkDefault false;
            vfr = lib.mkDefault true;
            vrr = lib.mkDefault 1;
          };

          render = {
            direct_scanout = lib.mkDefault false;
            explicit_sync = lib.mkDefault 1;
          };

          xwayland = {
            enabled = lib.mkDefault true;
            force_zero_scaling = lib.mkDefault true;
          };

          # Binds
          bind = [
            # Window Management Binds
            "${mainMod}, F, fullscreen,"
            "${mainMod}, Q, killactive,"
            "${mainMod}, S, togglefloating,"
            "${mainMod}, J, togglesplit,"
            "${mainMod} CONTROL, right, resizeactive, 30 0"
            "${mainMod} CONTROL, left, resizeactive, -30 0"
            "${mainMod} CONTROL, up, resizeactive, 0 -30"
            "${mainMod} CONTROL, down, resizeactive, 0 30"

            # Movement Binds
            "${mainMod}, up, movefocus, u"
            "${mainMod}, down, movefocus, d"
            "${mainMod}, left, movefocus, l"
            "${mainMod}, right, movefocus, r"
            "${mainMod} ALT, left, movewindow, l"
            "${mainMod} ALT, right, movewindow, r"
            "${mainMod} ALT, up, movewindow, u"
            "${mainMod} ALT, down, movewindow, d"

            # Workspace Binds
            "${mainMod}, 1, split:workspace, 1"
            "${mainMod}, 2, split:workspace, 2"
            "${mainMod}, 3, split:workspace, 3"
            "${mainMod}, 4, split:workspace, 4"
            "${mainMod}, 5, split:workspace, 5"
            "${mainMod}, 6, split:workspace, 6"
            "${mainMod}, 7, split:workspace, 7"
            "${mainMod}, 8, split:workspace, 8"
            "${mainMod}, 9, split:workspace, 9"
            "${mainMod}, 0, split:workspace, 10"
            "${mainMod} SHIFT, 1, split:movetoworkspace, 1"
            "${mainMod} SHIFT, 2, split:movetoworkspace, 2"
            "${mainMod} SHIFT, 3, split:movetoworkspace, 3"
            "${mainMod} SHIFT, 4, split:movetoworkspace, 4"
            "${mainMod} SHIFT, 5, split:movetoworkspace, 5"
            "${mainMod} SHIFT, 6, split:movetoworkspace, 6"
            "${mainMod} SHIFT, 7, split:movetoworkspace, 7"
            "${mainMod} SHIFT, 8, split:movetoworkspace, 8"
            "${mainMod} SHIFT, 9, split:movetoworkspace, 9"
            "${mainMod} SHIFT, 0, split:movetoworkspace, 10"

            # Volume Binds
            ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0"
            ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.0"
            ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"

            # Program Binds
            "${mainMod}, return, exec, foot"
            "${mainMod}, R, exec, dolphin"
            "${mainMod}, B, exec, firefox"
            "${mainMod}, K, exec, keepassxc"

            "${mainMod}, SPACE, exec, qs msg launcher toggle"
            "${mainMod}, O, exec, qs msg settings toggle"
            "${mainMod}, N, exec, qs msg notifications toggle"
            "${mainMod}, P, exec, qs msg screencapture screenshot"
            "${mainMod}, L, exec, qs msg lockscreen lock"
            ", XF86AudioNext, exec, qs msg mpris next"
            ", XF86AudioPause, exec, qs msg mpris play_pause"
            ", XF86AudioPlay, exec, qs msg mpris play_pause"
            ", XF86AudioPrev, exec, qs msg mpris prev"
          ];

          bindm = [
            "${mainMod}, mouse:272, movewindow"
            "${mainMod}, mouse:273, resizewindow"
          ];

          windowrulev2 = [
            "immediate, xwayland:1"
            "float, class:org.kde.polkit-kde-authentication-agent-1"
            "float, class:org.freedesktop.impl.portal.desktop.kde"
            "suppressevent maximize, class:.*"
          ];

          layerrule = [
            "blur, quickshell"
            "blurpopups, quickshell"
            # "ignorezero, quickshell"
            "ignorealpha 0.1, quickshell"
          ];
        };
      };
    };

    systemd.user.targets = {
      hyprland-session = {
        enable = true;
        bindsTo = ["graphical-session.target"];
        wants = ["graphical-session-pre.target"];
        after = ["graphical-session-pre.target"];
      };
    };

    users.users.${config.users.defaultUser}.file = {
      ".config/hypr/hyprland.conf".text =
        lib.optionalString (cfg.settings != {})
        (toHyprconf {
          attrs = cfg.settings;
          inherit (cfg) importantPrefixes;
        })
        + lib.optionalString (cfg.extraConf != "") cfg.extraConf;

      ".config/hypr/hypridle.conf".text = ''
        general {
          after_sleep_cmd=hyprctl dispatch dpms on
          ignore_dbus_inhibit=false
          lock_cmd=hyprctl dispatch dpms off
        }

        listener {
          on-timeout=qs msg lockscreen lock
          timeout=450
        }

        listener {
          on-resume=hyprctl dispatch dpms on
          on-timeout=hyprctl dispatch dpms off
          timeout=900
        }
      '';
    };
  };
}
