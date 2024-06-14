{
  inputs,
  outputs,
  ...
}: {
  # TODO: SPLIT THIS MESS INTO MUTIPLE FILES

  imports = [
    ./system
    outputs.universalModules
    outputs.nixosModules
    inputs.secrets.secretModules
  ];

  system.defaults = {
    enable = true;
    grub.enable = true;
  };

  environment = {
    sessionVariables = {
      NIXOS_OZONE_WL = "1";
      SHELL = "/run/current-system/sw/bin/zsh";
    };

    localBinInPath = true;
    enableDebugInfo = true;
  };

  networking.nm.enable = true;

  loginmanager.greetd = {
    gtkgreet.enable = true;
  };

  theme.oled.enable = true;
}
