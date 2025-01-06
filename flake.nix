{
  description = "Main nix configuration";

  outputs = inputs @ {
    self,
    nixpkgs,
    nixpkgs-stable,
    ...
  }: {
    overlays = import ./overlays {inherit inputs;};

    nixosConfigurations = {
      # Main desktop
      galahad = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs;};
        modules = [
          ./modules/nixos
          ./hosts/galahad
        ];
      };

      # Framework Laptop
      bulbel = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs;};
        modules = [
          ./modules/nixos
          ./hosts/bulbel
        ];
      };

      # Steamdeck
      compass = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit self inputs;};
        modules = [
          ./modules/nixos
          ./hosts/compass
        ];
      };

      # Home server
      cerebrite = nixpkgs-stable.lib.nixosSystem {
        specialArgs = {inherit self inputs;};
        modules = [
          ./modules/server
          ./hosts/cerebrite
        ];
      };

      # Routing VPS
      dahlia = nixpkgs-stable.lib.nixosSystem {
        specialArgs = {inherit self inputs;};
        modules = [
          ./modules/server
          ./hosts/dahlia
        ];
      };
    };
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";

    # Nix User Repository...
    nur.url = "github:nix-community/NUR";

    # Custom Neovim Dots
    custom-neovim = {
      url = "github:kossLAN/NvimFlake";
    };

    # Custom ZSH Dots
    custom-zsh = {
      url = "github:kossLAN/zsh-flake";
    };

    # Secrets 🤫
    agenix.url = "github:ryantm/agenix";

    # Package Flakes
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Hyprland Window Manager
    hyprland = {
      url = "github:hyprwm/Hyprland";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # App runner
    anyrun = {
      url = "github:Kirottu/anyrun";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Quickshell
    quickshell = {
      url = "github:outfoxxed/quickshell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Steamdeck Modules
    jovian = {
      url = "github:Jovian-Experiments/Jovian-Nixos/development";
      inputs.nixpkgs.follows = "nixpkgs-stable";
    };

    # Zen Browser
    zen-browser = {
      url = "github:youwen5/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Audio screensharing in firefox
    pipewire-screenaudio = {
      url = "github:IceDBorn/pipewire-screenaudio";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
