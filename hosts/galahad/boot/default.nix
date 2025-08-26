{
  pkgs,
  lib,
  ...
}: {
  boot = {
    kernelPackages = pkgs.linuxPackages_latest;

    loader.efi = {
      canTouchEfiVariables = true;
    };

    loader.grub = {
      efiSupport = true;
      enable = lib.mkDefault true;
      device = "nodev";
      useOSProber = true;
    };

    initrd = {
      availableKernelModules = [
        "nvme"
        "xhci_pci"
        "ahci"
        "usbhid"
        "sd_mod"
      ];
      kernelModules = [
        "snd_aloop"
        "i2c-dev"
        "amdgpu"
      ];
    };

    kernelModules = ["kvm-amd"];
    kernelParams = [
      "amd_iommu=on"
      "iommu=pt"
      "kvm.ignore_msrs=1"
      "kvm.report_ignored_msrs=0"
      "amdgpu.vm_update_mode=3"
    ];

    # Cross Compilation
    binfmt.emulatedSystems = [
      "riscv32-linux"
      "riscv64-linux"
      "x86_64-windows"
      "aarch64-linux"
    ];
  };
}
