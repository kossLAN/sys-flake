{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;

  cfg = config.virtualisation.libvirtd;
in {
  config = mkIf cfg.enable {
    programs.virt-manager.enable = true;

    virtualisation.libvirtd = {
      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;

        ovmf = {
          enable = true;
          packages = [
            (pkgs.OVMF.override {
              secureBoot = true;
              tpmSupport = true;
            })
            .fd
          ];
        };
      };
    };

    users.users.${config.users.defaultUser} = {
      extraGroups = ["libvirtd"];
    };
  };
}
