{
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    vesktop
    keepassxc
    prismlauncher
  ];

  programs = {
    common.enable = true;
    firefox.enable = true;
    git.enable = true;
    java.enable = true;

    neovim = {
      enable = true;
      defaultEditor = true;
    };
  };
}
