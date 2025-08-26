{pkgs, ...}: {
  config = {
    networking.networkmanager = {
      plugins = with pkgs; [
        networkmanager-openvpn 
        networkmanager-openconnect 
      ];

      wifi = {
        powersave = true;
      };
    };
  };
}
