{
  description = "FSH Shell Template";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
  };

  outputs = {
    self,
    nixpkgs,
  }: let
    forEachSystem = fn:
      nixpkgs.lib.genAttrs
      ["x86_64-linux" "aarch64-linux"]
      (system: fn system nixpkgs.legacyPackages.${system});
  in {
    devShells = forEachSystem (system: pkgs: {
      default =
        (pkgs.buildFHSEnv {
          name = "fhs-shell";

          targetPkgs = pkgs:
            with pkgs; [
              bash
              coreutils
            ];

          multiPkgs = pkgs:
            with pkgs; [
              # packages that are expected to conform to fhs
            ];

          profile = ''
            export PS1="\e[0;32m[fsh-env]\e[m \w $ "
          '';
        }).env;
    });
  };
}
