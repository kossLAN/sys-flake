{
  lib,
  config,
  ...
}: {
  config = {
    services.syncthing = {
      user = lib.mkDefault config.users.defaultUser;
      group = lib.mkDefault "users";
      dataDir = lib.mkDefault "/home/${config.users.defaultUser}";
      openDefaultPorts = true;
      overrideFolders = false;
      overrideDevices = false;
    };
  };
}
