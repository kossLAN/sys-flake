{
  self,
  inputs,
  config,
  ...
}: let
  path = "${self.outPath}/secrets";
in {
  imports = [inputs.agenix.nixosModules.default];

  age.secrets = {
    cloudflare.file = "${path}/cloudflare.age";
    openvpn-newyork.file = "${path}/openvpn/newyork.age";

    plausible-admin.file = "${path}/plausible/admin.age";
    plausible-keybase.file = "${path}/plausible/keybase.age";

    air0private = {
      file = "${path}/wireguard/air0/private.age";
      owner = toString config.ids.uids.systemd-network;
    };

    air0preshared = {
      file = "${path}/wireguard/air0/preshared.age";
      owner = toString config.ids.uids.systemd-network;
    };

    wg0 = {
      owner = toString config.ids.uids.systemd-network;
      file = "${path}/wireguard/wg0/private.age";
    };

    matrix = {
      file = "${path}/matrix.age";
      owner = toString config.ids.uids.matrix-synapse;
    };
  };
}
