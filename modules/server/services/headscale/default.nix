# This module breaks way to much, and I'm over it.
{
  config,
  lib,
  headscale,
  ...
}: let
  inherit (lib.options) mkOption;

  cfg = config.services.headscale;
in {
  options.services.headscale = {
    baseDomain = mkOption {
      type = lib.types.str;
      default = "ts.kosslan.me";
      description = "The base domain for headscale";
    };

    tailnetDomain = mkOption {
      type = lib.types.str;
      default = "kosslan.me";
    };

    tailnetRecords = mkOption {
      type = lib.types.listOf (lib.types.submodule {
        options = {
          name = lib.mkOption {
            type = lib.types.str;
            default = "";
            description = "The subdomain name";
          };

          value = lib.mkOption {
            type = lib.types.str;
            default = "100.64.0.1";
            description = "The value to associate with the subdomain";
          };
        };
      });
      default = [];
    };
  };

  config = {
    _module.args.headscale = {
      # Adds a subdomain to tailscale dns records
      tailnetFqdnList =
        builtins.map
        (subdomain: {
          name =
            if subdomain.name != ""
            then "${subdomain.name}.${cfg.tailnetDomain}"
            else cfg.tailnetDomain;
          value = subdomain.value;
        })
        cfg.tailnetRecords;
    };

    services.headscale = {
      settings = import ./config.nix {inherit lib config headscale;};
    };
  };
}
