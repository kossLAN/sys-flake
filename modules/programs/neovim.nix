{
  pkgs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) bool package;

  cfg = config.programs.neovim;
in {
  disabledModules = ["programs/neovim.nix"];

  options.programs.neovim = {
    enable = mkOption {
      type = bool;
      default = true;
    };

    package = mkOption {
      type = package;
      default = pkgs.nvim-pkg;
    };

    defaultEditor = lib.mkOption {
      type = bool;
      default = true;
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
