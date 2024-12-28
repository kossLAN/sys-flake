{
  pkgs,
  config,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vesktop
    keepassxc
    nvim-pkg
  ];

  programs = {
    common.enable = true;
    zen-browser.enable = true;
    git.enable = true;
    java.enable = true;

    nh = {
      enable = true;
      flake = "/home/${config.users.defaultUser}/.nixos-conf";
    };
  };
}
