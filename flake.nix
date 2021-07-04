{
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    home-manager = { url = "github:nix-community/home-manager"; };
    secrets = { url = "github:LavaDesu/flakes-secrets"; };

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: with inputs;
    let
      getPaths = root: builtins.map
        (path: root + ("/" + path)) # Prepends root path
        (builtins.attrNames (builtins.readDir root)); # Reads root path

      customPackages = pkgs:
        let
          callPackage = pkgs.callPackage;
        in {
          linux-lava = callPackage ./packages/linux-lava {};
          wine-osu = callPackage ./packages/wine-osu { inherit getPaths; };
        };

      overlays = (builtins.map
        (path: import path) # Imports path
        (builtins.filter
          (path: nixpkgs.lib.hasSuffix ".nix" path) # Checks file extension
          (getPaths ./overlays)
        )
      ) ++ [(self: super: customPackages super)];

      revCount = "299942";
      base = { config, ... }: {
        system = {
          configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          nixos = rec {
            version = config.system.nixos.release + versionSuffix;
            versionSuffix = ".${nixpkgs.lib.substring 0 8 (nixpkgs.lastModifiedDate or nixpkgs.lastModified or "19700101")}.r${revCount}-${nixpkgs.lib.substring 0 11 (nixpkgs.rev or "dirty")}";
          };
        };
        nix.registry.nixpkgs.flake = nixpkgs;
        nixpkgs.overlays = overlays;
      };

      hm-base = {
        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
        };
      };
    in
    {
      nixosConfigurations."winter" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          base
          home-manager.nixosModules.home-manager
          hm-base
          ./hosts/winter
          secrets.nixosModules.winter
        ];
      };
      packages.x86_64-linux = customPackages nixpkgs.legacyPackages.x86_64-linux;
    };
}
