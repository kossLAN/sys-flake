{pkgs, ...}: let
  group = "storage";
in {
  imports = [./deluge.nix];

  # WARN: This is cause the arr suite uses dotnet-sdk-6.
  nixpkgs.config.permittedInsecurePackages = [
    "dotnet-sdk-6.0.428"
    "aspnetcore-runtime-6.0.36"
  ];

  users = {
    groups.storage = {
      name = "storage";
      members = [
        "deluge"
        "lidarr"
        "sonarr"
        "radarr"
      ];
      gid = 8000;
    };
  };

  services = {
    flaresolverr = {
      enable = true;
      package = pkgs.nur.repos.xddxdd.flaresolverr-21hsmw;
    };

    sonarr = {
      enable = true;
      group = group;
    };

    radarr = {
      enable = true;
      group = group;
    };

    lidarr = {
      enable = true;
      package = pkgs.unstable.lidarr;
      group = group;
    };

    prowlarr = {
      enable = true;
    };

    jellyfin = {
      enable = true;
    };

    jellyseerr = {
      enable = true;
    };
  };
}
