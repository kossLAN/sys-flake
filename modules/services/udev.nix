{
  pkgs,
  lib,
  ...
}: let
  inherit (lib) mkDefault;
in {
  services = {
    udev = {
      enable = mkDefault true;
      packages = with pkgs; [
        via
        android-udev-rules
      ];
    };
  };
}
