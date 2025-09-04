{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) filterAttrs versionOlder mkDefault;
  inherit (builtins) match tryEval attrValues;
in {
  networking.hostId = "8425e349";
  services.zfs.autoScrub.enable = true;

  # set latest zfs available zfs suppported kernel
  boot.kernelPackages = let
    zfsCompatibleKernelPackages =
      filterAttrs (
        name: kernelPackages:
          (match "linux_[0-9]+_[0-9]+" name)
          != null
          && (tryEval kernelPackages).success
          && (!kernelPackages.${config.boot.zfs.package.kernelModuleAttribute}.meta.broken)
      )
      pkgs.linuxKernel.packages;
    latestKernelPackage = lib.last (
      lib.sort (a: b: (versionOlder a.kernel.version b.kernel.version)) (
        attrValues zfsCompatibleKernelPackages
      )
    );
  in
    mkDefault latestKernelPackage;
}
