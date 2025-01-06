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
          foreground = "cdcdcd";
          background = "000000";
          regular0 = "000000";
          regular1 = "ff8599";
          regular2 = "00c545";
          regular3 = "de9d00";
          regular4 = "00b4ff";
          regular5 = "fd71f8";
          regular6 = "00bfae";
          regular7 = "cdcdcd";
          bright0 = "262626";
          bright1 = "ff9eb2";
          bright2 = "19de5e";
          bright3 = "f7b619";
          bright4 = "19cdff";
          bright5 = "ff8aff";
          bright6 = "19d8c7";
          bright7 = "dadada";
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
