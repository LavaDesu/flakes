{
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    home-manager = { url = "github:LavaDesu/home-manager/aa"; };
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
        in rec {
          linux_lava = callPackage ./packages/linux-lava {};
          linux_tkg = callPackage ./packages/linux-tkg {
            kernelPatches = with pkgs.kernelPatches; [
              bridge_stp_helper
              request_key_helper
            ];
          };
          linuxPackages_tkg = args: pkgs.recurseIntoAttrs (pkgs.linuxPackagesFor (linux_tkg.override args));
          wine-osu = callPackage ./packages/wine-osu { inherit getPaths; };
        }
        # For github workflow tests
        // builtins.listToAttrs (builtins.map (e: {
          name = "linux_tkg-${e.scheduler}-${pkgs.lib.stringAsChars (x: if x == "." then "" else x) e.version}";
          value = callPackage ./packages/linux-tkg {
            inherit (e) scheduler version;
            kernelPatches = with pkgs.kernelPatches; [
              bridge_stp_helper
              request_key_helper
            ];
          };
        }) (pkgs.lib.cartesianProductOfSets {
          scheduler = ["bmq" "cfs" "cacule" "muqss" "pds"];
          version = ["5.4" "5.10" "5.11"];
        })) // {
          "linux_tkg-upds-510" = callPackage ./packages/linux-tkg {
            version = "5.10";
            scheduler = "upds";
            kernelPatches = with pkgs.kernelPatches; [
              bridge_stp_helper
              request_key_helper
            ];
          };
        };

      overlays = (builtins.map
        (path: import path) # Imports path
        (builtins.filter
          (path: nixpkgs.lib.hasSuffix ".nix" path) # Checks file extension
          (getPaths ./overlays)
        )
      ) ++ [(self: super: customPackages super)];

      revCount = "297098";
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
