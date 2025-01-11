{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.programs.foot;
in {
  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      wl-clipboard
    ];

    programs.foot = {
      settings = {
        main = {
          shell = "zsh";
          term = "xterm-256color";
          font = "DejaVuSansM Nerd Font:size=12";
        };

        cursor = {
          color = "181818 cdcdcd";
        };

        colors = {
          alpha = 1.0;

          foreground = "d3c6aa";
          background = "272e33";

          regular0 = "475258";
          regular1 = "e67e80";
          regular2 = "a7c080";
          regular3 = "dbbc7f";
          regular4 = "7fbbb3";
          regular5 = "d699b6";
          regular6 = "83c092";
          regular7 = "d3c6aa";

          bright0 = "475258";
          bright1 = "e67e80";
          bright2 = "a7c080";
          bright3 = "dbbc7f";
          bright4 = "7fbbb3";
          bright5 = "d699b6";
          bright6 = "83c092";
          bright7 = "d3c6aa";

          "16" = "e69875";
          "17" = "d3c6aa";

          selection-foreground = "d3c6aa";
          selection-background = "3c474d";

          search-box-no-match = "2d353b e67e80";
          search-box-match = "d3c6aa 3c474d";

          jump-labels = "2d353b e69875";
          urls = "7fbbb3";
        };

        key-bindings = {
          scrollback-up-page = "Shift+Page_Up";
          scrollback-up-half-page = "none";
          scrollback-up-line = "none";
          scrollback-down-page = "Shift+Page_Down";
          scrollback-down-half-page = "none";
          scrollback-down-line = "none";
          scrollback-home = "none";
          scrollback-end = "none";
          clipboard-copy = "Control+Shift+c XF86Copy";
          clipboard-paste = "Control+Shift+v XF86Paste";
          primary-paste = "Shift+Insert";
          search-start = "Control+Shift+r";
          font-increase = "Control+plus Control+equal Control+KP_Add";
          font-decrease = "Control+minus Control+KP_Subtract";
          font-reset = "Control+0 Control+KP_0";
          spawn-terminal = "Control+Shift+n";
          minimize = "none";
          maximize = "none";
          fullscreen = "none";
          pipe-visible = "[sh -c 'xurls | fuzzel | xargs -r firefox'] none";
          pipe-scrollback = "[sh -c 'xurls | fuzzel | xargs -r firefox'] none";
          pipe-selected = "[xargs -r firefox] none";
          pipe-command-output = "[wl-copy] none"; # Copy last command's output to the clipboard
          show-urls-launch = "Control+Shift+o";
          show-urls-copy = "none";
          show-urls-persistent = "none";
          prompt-prev = "Control+Shift+z";
          prompt-next = "Control+Shift+x";
          unicode-input = "Control+Shift+u";
          noop = "none";
        };
      };
    };
  };
}
