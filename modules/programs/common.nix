{
  inputs,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    # terminal apps
    btop-rocm
    nmap
    ripgrep
    fastfetch
    zls
    xxd
    killall
    file
    usbutils
    inputs.agenix.packages.${pkgs.stdenv.system}.default

    # graphical utils
    vlc
    keepassxc
  ];
}
