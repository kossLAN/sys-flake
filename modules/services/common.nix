{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.services.common;
in {
  # Essentially just basic services I tend to use on all my linux installs.
  options.services.common = {
    enable = mkEnableOption "common";
  };

  config = mkIf cfg.enable {
    services = {
      devmon.enable = true;
      gvfs.enable = true;
      udisks2.enable = true;
      dbus.enable = true;
      sound.enable = true;
    };
  };
}
