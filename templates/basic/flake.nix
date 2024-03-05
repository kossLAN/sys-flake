{
  description = "A basic as fuck flake template";

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
      default = pkgs.mkShell {
        buildInputs = with pkgs; [];
      };
    });
  };
}
