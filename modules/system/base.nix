{ config, inputs, modules, overlays, ... }: {
  system = {
    configurationRevision = inputs.self.rev;
    nixos = rec {
      version = config.system.nixos.release + versionSuffix;
      versionSuffix = "-${config.system.name}.r${builtins.toString inputs.self.revCount}.${inputs.self.shortRev}";
    };
  };
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nixpkgs.overlays = overlays;

  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit inputs modules;
      enableGUI = true;
    };
  };
}
