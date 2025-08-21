{
  description = "System flake for personal computers.";

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    ...
  }: {
    overlays = import ./overlays {inherit inputs;};
    templates = import ./templates;
    nixosModules.nixos = import ./modules;

    nixosConfigurations = builtins.listToAttrs (builtins.map (name: {
        inherit name;
        value = nixpkgs.lib.nixosSystem {
          specialArgs = {inherit self inputs;};
          modules = [
            ./modules
            ./hosts/${name}
          ];
        };
      }) [
        "galahad" # desktop
        "bulbel" # laptop
        "compass" # steamdeck
      ]);
  };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-25.05";

    nixos-hardware.url = "github:nixos/nixos-hardware";
    nur.url = "github:nix-community/NUR";
    custom-neovim.url = "github:kossLAN/nvim-flake";
    custom-zsh.url = "github:kossLAN/zsh-flake";
    agenix.url = "github:ryantm/agenix";
    dots.url = "github:kossLAN/dots";

    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    jovian = {
      url = "github:Jovian-Experiments/Jovian-Nixos/development";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };
  };
}
