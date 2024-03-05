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
          font = "DejaVuSansM Nerd Font:size=14";
          gamma-correct-blending = "no";
        };

        cursor = {
          color = "181818 cdcdcd";
        };

        # Catppuccin
        colors = {
          alpha = 1.0;
          alpha-mode = "matching";

          foreground = lib.mkDefault "cad3f5";
          background = lib.mkDefault "24273a";

          regular0 = lib.mkDefault "494d64"; # black
          regular1 = lib.mkDefault "ed8796"; # red
          regular2 = lib.mkDefault "a6da95"; # green
          regular3 = lib.mkDefault "eed49f"; # yellow
          regular4 = lib.mkDefault "8aadf4"; # blue
          regular5 = lib.mkDefault "f5bde6"; # magenta
          regular6 = lib.mkDefault "8bd5ca"; # cyan
          regular7 = lib.mkDefault "b8c0e0"; # white

          bright0 = lib.mkDefault "5b6078"; # bright black
          bright1 = lib.mkDefault "ed8796"; # bright red
          bright2 = lib.mkDefault "a6da95"; # bright green
          bright3 = lib.mkDefault "eed49f"; # bright yellow
          bright4 = lib.mkDefault "8aadf4"; # bright blue
          bright5 = lib.mkDefault "f5bde6"; # bright magenta
          bright6 = lib.mkDefault "8bd5ca"; # bright cyan
          bright7 = lib.mkDefault "cad3f5"; # bright white

          "16" = lib.mkDefault "f5a97f"; # orange
          "17" = lib.mkDefault "b7bdf8"; # additional color

          selection-foreground = lib.mkDefault "24273a";
          selection-background = lib.mkDefault "8aadf4";

          search-box-no-match = lib.mkDefault "24273a ed8796";
          search-box-match = lib.mkDefault "24273a a6da95";

          jump-labels = lib.mkDefault "24273a f5a97f";
          urls = lib.mkDefault "8aadf4";
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
