{...}: {
  programs.waybar = {
    style = ./style.css;
    settings = [
      {
        layer = "top";
        height = 30;
        modules-left = [
          "hyprland/workspaces"
        ];
        modules-center = [
          "clock"
          "mpris"
        ];
        modules-right = [
          "tray"
          "cpu"
          "memory"
          "bluetooth"
          "network"
          "custom/swaync"
        ];
        wireplumber = {
          format = "{icon} {volume}%  ";
          format-muted = " MUTE ";
          on-click = "pactl set-sink-mute @DEFAULT_SINK@ toggle";
          on-click-right = "pavucontrol";
          max-volume = 100;
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          reverse-scrolling = true;
          scroll-step = 0.4;
        };
        backlight = {
          reverse-scrolling = false;
          scroll-step = 0.6;
          device = "intel_backlight";
          format = "    {percent}%   ";
        };
        clock = {
          format = "{:%I:%M %p}";
          tooltip-format = "{:%A, %B %d, %Y (%R)}";
        };
        cpu = {
          interval = 10;
          format = " {}% ";
          max-length = 10;
        };
        memory = {
          interval = 30;
          format = " {}%  ";
          max-length = 10;
        };
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = true;
        };
        mpris = {
          format = " {status_icon} {title} - {artist}  ";
          status-icons = {
            paused = " ⏸ ";
            playing = "  ";
          };
          max-length = 35;
        };
        tray = {
          icon-size = 15;
          spacing = 20;
        };
        # battery = {
        #   format = " {icon}   {capacity}%   ";
        #   format-icons = [
        #     ""
        #     ""
        #     ""
        #     ""
        #     ""
        #   ];
        #   max-length = 16;
        # };
        network = {
          format-wifi = "    ";
          format = "    ";
          tooltip-format = "{signaldBm}dBm {essid} {frequency}GHz";
          on-click = "nm-connection-editor";
        };
        bluetooth = {
          format = " ";
          on-click = "blueman-manager";
          format-connected = "    {device_alias}";
          format-connected-battery = " {device_alias} {device_battery_percentage}%";
          tooltip-format = "{controller_alias}\t{controller_address}\n\n{num_connections} connected";
          tooltip-format-connected = "{controller_alias}\t{controller_address}\n\n{num_connections} connected\n\n{device_enumerate}";
          tooltip-format-enumerate-connected = "{device_alias}\t{device_address}";
          tooltip-format-enumerate-connected-battery = "{device_alias}\t{device_address}\t{device_battery_percentage}%";
        };
        "custom/swaync" = {
          on-click = "swaync-client -t";
          format = " ";
        };
      }
    ];
  };
}
