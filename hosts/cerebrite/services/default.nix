{pkgs, ...}: {
  virtualisation = {
    portainer.enable = true;
  };

  users = {
    groups.storage = {
      name = "storage";
      members = [
        "syncthing"
      ];
      gid = 8000;
    };
  };

  services = {
    ssh.enable = true;
    matrix.container.enable = true;
    forgejo.container.enable = true;

    caddy = {
      enable = true;
      email = "kosslan@kosslan.dev";
    };

    # Private Services
    syncthing = {
      enable = true;
      group = "storage";
      guiAddress = "0.0.0.0:8384";
      openDefaultPorts = true;
      overrideFolders = false;
      overrideDevices = false;
    };

    hardware.openrgb = {
      enable = true;
      motherboard = "amd";
    };

    ollama = {
      enable = true;
      host = "0.0.0.0";
      acceleration = "cuda";
    };

    open-webui = {
      enable = true;
      host = "0.0.0.0";
      port = 12121;
    };

    netdata = {
      enable = true;

      package = pkgs.netdata.override {
        withCloudUi = true;
      };

      python = {
        enable = true;
        recommendedPythonPackages = true;
      };
    };
  };
}
