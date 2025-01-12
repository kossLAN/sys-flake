{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.virtualisation.incus;
in {
  config = mkIf cfg.enable {
    virtualisation.incus = {
      package = pkgs.incus;
      # agent.enable = true;
      ui.enable = true;
    };
  };
}
