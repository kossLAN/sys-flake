{inputs, ...}: {
  additions = final: _prev:
    import ../pkgs {
      pkgs = final;
    };

  modifications = final: prev: {
  };

  # Allows me to use stable/unstable packages where I need them.
  stable-packages = final: _prev: {
    stable = import inputs.nixpkgs-stable {
      system = final.system;
      config.allowUnfree = true;
    };
  };

  unstable-packages = final: _prev: {
    unstable = import inputs.nixpkgs {
      system = final.system;
      config.allowUnfree = true;
    };
  };
}
