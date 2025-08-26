{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.options) mkOption;
in {
  options.users = {
    defaultUser = mkOption {
      type = lib.types.str;
      default = "koss";
    };

    users = mkOption {
      type = lib.types.attrsOf (lib.types.submoduleWith {
        modules = [
          ({lib, ...}: {
            options.file = mkOption {
              type = lib.types.attrsOf (lib.types.submodule {
                options = {
                  text = mkOption {
                    type = lib.types.nullOr (lib.types.str);
                    default = null;
                    description = "Test of the file you want to link.";
                  };

                  source = mkOption {
                    type = lib.types.path;
                    description = "Source of the file you want to link.";
                  };
                };
              });
              default = {};
              description = ''
                Files to be created in the user's home directory.
                The attribute name is the relative path from the home directory.
              '';
            };
          })
        ];
        shorthandOnlyDefinesConfig = true;
      });
    };
  };

  config = {
    programs.zsh = {
      enable = true;
      shellInit = "autoload -Uz add-zsh-hook";
    };

    users = {
      defaultUserShell = pkgs.zsh;
      users.${config.users.defaultUser} = {
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager" "dialout" "libvirtd"];
        initialPassword = "root";
      };
    };

    # TODO: Implement proper file unlinking.
    systemd.services = lib.filterAttrs (_: v: v != {}) (lib.mapAttrs' (
        username: userConfig:
          lib.nameValuePair "manage-user-files-${username}" (
            if (userConfig.file or {}) != {}
            then {
              description = "Manage dotfiles linking for ${username}";
              wantedBy = ["multi-user.target"];
              restartIfChanged = true;

              serviceConfig = {
                Type = "oneshot";
                RemainAfterExit = true;
                User = username;

                ExecStart = pkgs.writeShellScript "manage-user-files-${username}" ''
                  ${lib.concatStringsSep "\n" (lib.mapAttrsToList (filename: fileConfig: let
                      home = config.users.users.${username}.home;
                      file =
                        if (fileConfig.text == null)
                        then fileConfig.source
                        else pkgs.writeText filename fileConfig.text;
                    in ''
                      mkdir -p "$(dirname "${home}/${filename}")"
                      ln -sf "${file}" "${home}/${filename}"
                    '')
                    userConfig.file)}
                '';
              };
            }
            else {}
          )
      )
      config.users.users);
  };
}
