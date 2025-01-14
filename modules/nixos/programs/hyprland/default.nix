{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) listOf str;

  cfg = config.programs.hyprland;
in {
  options.programs.hyprland = {
    extraConf = mkOption {
      type = str;
      default = "";
    };
  };

  config = mkIf cfg.enable {
    # XDG Portal Nonsense
    xdg.portal = {
      enable = true;
      extraPortals = [pkgs.libsForQt5.xdg-desktop-portal-kde];
      xdgOpenUsePortal = true;

      config.hyprland = {
        default = [
          "hyprland"
          "gtk"
        ];

        "org.freedesktop.impl.portal.FileChooser" = [
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
        GDK_BACKEND = "wayland";
      };

      systemPackages = with pkgs; [
        hyprland-qtutils
        libsForQt5.dolphin
        libsForQt5.gwenview
        libsForQt5.ark
        libsForQt5.kdenlive
      ];
    };

    # Breeze theme
    theme.presets.breeze.enable = true;

    programs = {
      nm-applet.enable = true;
      quickshell.enable = true;

      hyprland = {
        # package = inputs.hyprland.packages.${pkgs.system}.default;
        # portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
        xwayland.enable = true;
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
      ".config/hypr/hyprland.conf".text = let
        mainmod = "SUPER";
      in ''
        exec-once = ${lib.getExe' pkgs.dbus "dbus-update-activation-environment"} --systemd --all && systemctl --user stop hyprland-session.target && systemctl --user start hyprland-session.target
        exec-once = ${lib.getExe pkgs.swaybg} -m fill -i ${./wallpaper.jpg}
        exec-once = ${lib.getExe pkgs.hypridle}
        exec=${pkgs.libsForQt5.polkit-kde-agent}/libexec/polkit-kde-authentication-agent-1
        exec=quickshell

        ${cfg.extraConf}

        input {
          accel_profile = "flat";
        }

        animations {
          bezier = linear, 0.5, 0.5, 0.5, 0.5
          bezier = antiEase, 0.6, 0.4, 0.6, 0.4
          bezier = ease, 0.4, 0.6, 0.4, 0.6
          bezier = smooth, 0.5, 0.9, 0.6, 0.95
          bezier = htooms, 0.95, 0.6, 0.9, 0.5
          bezier = powered, 0.5, 0.2, 0.6, 0.5
          animation = windows, 1, 2.5, smooth
          animation = windowsOut, 1, 1, htooms, popin 80%
          animation = fade, 1, 5, smooth
          animation = workspaces, 1, 6, default
          enabled = true
        }

        decoration {
          blur {
            enabled = false
            contrast = 1
            new_optimizations = true
            noise = 0
            passes = 5
            size = 8
          }

          shadow {
            enabled = true
            range = 5
          }

          rounding = 5
        }

        dwindle {
          force_split = 2
          preserve_split = true
          pseudotile = true
          smart_resizing = true
          smart_split = false
        }

        general {
          # allow_tearing = true
          border_size = 2
          col.active_border = rgba(589D95ff)
          col.inactive_border = rgba(64727db3)
          gaps_in = 3
          gaps_out = 5
          layout = dwindle
          resize_on_border = true
        }

        input {
          accel_profile = flat
          follow_mouse = 1
          kb_layout = us
          kb_model =
          kb_options =
          kb_rules =
          kb_variant =
          sensitivity = 0

          touchpad{
            disable_while_typing=true
            clickfinger_behavior=true
          }
        }

        gestures {
          workspace_swipe = 1
          workspace_swipe_fingers = 3
          workspace_swipe_distance = 200
          workspace_swipe_min_speed_to_force = 0
          workspace_swipe_create_new = false
          workspace_swipe_cancel_ratio = 0.5
          workspace_swipe_forever = true
          workspace_swipe_direction_lock = false
        }

        misc {
          animate_manual_resizes = false
          disable_hyprland_logo = true
          focus_on_activate = false
          key_press_enables_dpms = true
          mouse_move_enables_dpms = true
          render_ahead_of_time = false
          vfr = true
          vrr = 0
        }

        render {
          direct_scanout = false
          explicit_sync = 1
          explicit_sync_kms = 2
        }

        xwayland {
          enabled = true
          force_zero_scaling = true
        }

        # BINDS

        ## Window Management Binds
        bind = ${mainmod}, F, fullscreen,
        bind = ${mainmod}, Q, killactive,
        bind = ${mainmod}, S, togglefloating,
        bind = ${mainmod}, J, togglesplit,
        bind = ${mainmod} CONTROL, right , resizeactive , 30  0
        bind = ${mainmod} CONTROL, left  , resizeactive , -30 0
        bind = ${mainmod} CONTROL, up    , resizeactive , 0   -30
        bind = ${mainmod} CONTROL, down  , resizeactive , 0   30

        ## Movement Binds
        bind = ${mainmod}, up   , movefocus, u
        bind = ${mainmod}, down , movefocus, d
        bind = ${mainmod}, left , movefocus, l
        bind = ${mainmod}, right, movefocus, r
        bind = ${mainmod} ALT , left  , movewindow, l
        bind = ${mainmod} ALT , right , movewindow, r
        bind = ${mainmod} ALT , up    , movewindow, u
        bind = ${mainmod} ALT , down  , movewindow, d

        ## Workspace Binds
        bind = ${mainmod} , 1   , workspace , 1
        bind = ${mainmod} , 2   , workspace , 2
        bind = ${mainmod} , 3   , workspace , 3
        bind = ${mainmod} , 4   , workspace , 4
        bind = ${mainmod} , 5   , workspace , 5
        bind = ${mainmod} , 6   , workspace , 6
        bind = ${mainmod} , 7   , workspace , 7
        bind = ${mainmod} , 8   , workspace , 8
        bind = ${mainmod} , 9   , workspace , 9
        bind = ${mainmod} , 0   , workspace , 10
        bind = ${mainmod} SHIFT , 1 , movetoworkspace , 1
        bind = ${mainmod} SHIFT , 2 , movetoworkspace , 2
        bind = ${mainmod} SHIFT , 3 , movetoworkspace , 3
        bind = ${mainmod} SHIFT , 4 , movetoworkspace , 4
        bind = ${mainmod} SHIFT , 5 , movetoworkspace , 5
        bind = ${mainmod} SHIFT , 6 , movetoworkspace , 6
        bind = ${mainmod} SHIFT , 7 , movetoworkspace , 7
        bind = ${mainmod} SHIFT , 8 , movetoworkspace , 8
        bind = ${mainmod} SHIFT , 9 , movetoworkspace , 9
        bind = ${mainmod} SHIFT , 0 , movetoworkspace , 10

        ## Volume Binds
        bind =, XF86AudioRaiseVolume , exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%+ -l 1.0
        bind =, XF86AudioLowerVolume , exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%- -l 1.0
        bind =, XF86AudioMute        , exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle

        ## Program Binds
        bind = ${mainmod}, return , exec, foot
        bind = ${mainmod}, R      , exec, dolphin
        bind = ${mainmod}, B      , exec, firefox
        bind = ${mainmod}, SPACE  , exec, qs msg -c shell.qml launcher open
        bind = ${mainmod}, P      , exec, ${lib.getExe pkgs.grimblast} --notify copysave area ~/Pictures/Screenshots/$(data + 'Screenshot_%s.png')

        ## Mouse Binds
        bindm= ${mainmod}, mouse:272 , movewindow
        bindm= ${mainmod}, mouse:273 , resizewindow

        # Window Rules
        windowrulev2=immediate  , xwayland:1
        windowrulev2=float                  , class:org.kde.polkit-kde-authentication-agent-1
        windowrulev2=float                  , class:org.freedesktop.impl.portal.desktop.kde
        windowrulev2=suppressevent maximize , class:.*
      '';

      ".config/hypr/hypridle.conf".text = ''
        general {
          after_sleep_cmd=hyprctl dispatch dpms on
          ignore_dbus_inhibit=false
          lock_cmd=hyprctl dispatch dpms off
        }

        listener {
          on-resume=hyprctl dispatch dpms on
          on-timeout=hyprctl dispatch dpms off
          timeout=300
        }
      '';
    };
  };
}
