{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.programs.steam;
in {
  config = mkIf cfg.enable {
    environment = {
      systemPackages = with pkgs; [
        scanmem
        protonup-qt
        wine
        winetricks
      ];
    };

    programs = {
      steam = {
        remotePlay.openFirewall = lib.mkDefault true;
        localNetworkGameTransfers.openFirewall = lib.mkDefault true;
        extest.enable = lib.mkDefault true;
        protontricks.enable = lib.mkDefault true;
      };

      gamemode.enable = true;
    };
  };
}
