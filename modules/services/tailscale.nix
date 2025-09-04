{lib, ...}: let
  inherit (lib) mkDefault;
in {
  services.tailscale = {
    enable = mkDefault true;
    useRoutingFeatures = "client";
  };
}
