{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.udevRules;
in {
  options.services.udevRules = {
    enable = mkEnableOption "udevRules";
    keyboard.enable = lib.mkEnableOption "keyboard";
  };

  config = mkIf cfg.enable {
    services = lib.mkIf cfg.keyboard.enable {
      udev = {
        packages = with pkgs; [
          via
        ];
      };
    };
  };
}
