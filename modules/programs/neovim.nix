{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;

  cfg = config.programs.neovim;
in {
  disabledModules = ["programs/neovim.nix"];

  options.programs.neovim = {
    enable = mkEnableOption "neovim :3";

    package = mkOption {
      type = lib.types.package;
      default = pkgs.nvim-pkg;
    };

    defaultEditor = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable {
    environment = {
      systemPackages = [
        cfg.package
      ];

      variables.EDITOR = lib.mkIf cfg.defaultEditor (lib.mkOverride 900 "nvim");
    };
  };
}
