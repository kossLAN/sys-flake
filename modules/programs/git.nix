{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.programs.git;
in {
  config = mkIf cfg.enable {
    programs.git = {
      config = {
        user = {
          email = "kosslan@kosslan.dev";
          name = "kossLAN";
          signingkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHrZvFPiVH1pHCm5XhA3ZQCL8fUsgJQxvfqY0pbg+5NI kosslan@kosslan.dev";
        };

        gpg = {
          format = "ssh";
        };

        commit = {
          gpgsign = true;
        };
      };
    };
  };
}
