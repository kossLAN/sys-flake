{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.programs.java;
in {
  config = mkIf cfg.enable {
    programs = {
      java = {
        package = pkgs.openjdk;
        binfmt = true;
      };
    };
  };
}
