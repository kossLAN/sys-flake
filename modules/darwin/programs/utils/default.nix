{
  pkgs,
  lib,
  config,
  ...
}: let
  cfg = config.programs.utils;
in {
  imports = [./trampoline];

  options.programs.utils = {
    enable = lib.mkEnableOption "utils";
  };

  config = lib.mkIf cfg.enable {
    home-manager.users.${config.users.defaultUser} = {
      home.packages = with pkgs; [
        nerdfonts
        iterm2
        discord
        gimp
        prismlauncher
      ];
    };
  };
}