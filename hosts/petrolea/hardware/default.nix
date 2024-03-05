{
  config,
  lib,
  modulesPath,
  pkgs,
  ...
}: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  networking.useDHCP = false;

  boot = {
    kernelPackages = pkgs.linuxPackages_6_6;
    kernelModules = ["kvm-amd"];
    extraModulePackages = [];

    initrd = {
      enable = true;

      availableKernelModules = [
        "xhci_pci"
        "ahci"
        "nvme"
        "usb_storage"
        "usbhid"
        "sd_mod"
        "sr_mod"
        "igb" # needed for connection
      ];

      ssh.enable = true;
      dhcp.enable = true;
    };
  };

  fileSystems = {
    "/" = {
      device = "rpool/root";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/nix" = {
      device = "rpool/nix";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/var" = {
      device = "rpool/var";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/home" = {
      device = "rpool/home";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/var/lib/nixos-mounts" = {
      device = "rpool/nixos-mounts";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/media" = {
      device = "mpool/media";
      fsType = "zfs";
      options = ["zfsutil"];
    };

    "/boot" = {
      device = "/dev/disk/by-uuid/91ED-A0DD";
      fsType = "vfat";
      options = ["fmask=0022" "dmask=0022"];
    };
  };

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  # networking.useDHCP = lib.mkDefault false;
  # networking.useNetworkd = true;
  # networking.interfaces.enp35s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp36s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp3s0f0u14u3c2.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
