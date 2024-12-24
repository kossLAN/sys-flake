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
    av0client1.file = "${path}/av0client1.age";
    av0preshared.file = "${path}/av0preshared.age";
    cloudflare.file = "${path}/cloudflare.age";

    matrix = {
      file = "${path}/matrix.age";
      owner = toString config.ids.uids.matrix-synapse;
    };

    deluge = {
      file = "${path}/deluge.age";
      owner = config.services.deluge.user;
    };
  };
}
