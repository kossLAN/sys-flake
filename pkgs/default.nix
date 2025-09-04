{pkgs ? (import ../nixpkgs.nix) {}, ...}: {
  # A place to add custom packages, essentially if they don't already exist in nixpkgs
  # example = pkgs.callPackage ./example { };

  grayjay = pkgs.callPackage ./grayjay {};
}
