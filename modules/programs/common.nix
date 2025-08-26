{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption;

  cfg = config.programs.common;
in {
  # Common apps...
  options.programs.common = {
    enable = mkEnableOption "Basic Utils";
  };

  config = mkIf cfg.enable {
    environment.systemPackages = with pkgs; [
      btop-rocm
      nmap
      ripgrep
      fastfetch
      zls
      xxd
      killall
      file
      usbutils
    ];
  };
}
