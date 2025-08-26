{...}: {
  networking = {
    networkmanager.enable = true;

    firewall = {
      allowedTCPPorts = [27040];
      allowedUDPPorts = [27036];
    };
  };
}
