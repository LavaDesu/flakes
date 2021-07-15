{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    secrets.url = "github:LavaDesu/flakes-secrets";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";

    # zsh plugins
    zsh-abbr = { url = "github:olets/zsh-abbr"; flake = false; };
    zsh-history-substring-search = { url = "github:zsh-users/zsh-history-substring-search"; flake = false; };
    fast-syntax-highlighting = { url = "github:zdharma/fast-syntax-highlighting"; flake = false; };
    pure = { url = "github:sindresorhus/pure"; flake = false; };
  };

  outputs = inputs: with inputs;
    let
      lib = nixpkgs.lib;

      getPaths = root: builtins.map
        (path: root + ("/" + path)) # Prepends root path
        (builtins.attrNames (builtins.readDir root)); # Reads root path

      modules =
      let
        getName = path: lib.removeSuffix ".nix" ( # Strip extension
          lib.last (                              # Gets the last part (filename)
            lib.splitString "/" (                 # Splits the path into components
              builtins.toString path              # Converts the path into a string
            )
          )
        );
        genModulePaths = basePath: builtins.listToAttrs (
          builtins.map (path: {
            name = getName path;
            value = path;
          }) (getPaths basePath)
        );
      in {
        user = genModulePaths ./modules/user;
        system = genModulePaths ./modules/system;
      };

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
          (path: lib.hasSuffix ".nix" path) # Checks file extension
          (getPaths ./overlays)
        )
      ) ++ [(self: super: customPackages super)]
        ++ [inputs.neovim-nightly.overlay];

      base = if !(self ? rev) then throw "Dirty git tree detected." else
      { config, ... }: {
        system = {
          configurationRevision = self.rev;
          nixos = rec {
            version = config.system.nixos.release + versionSuffix;
            versionSuffix = "-${config.system.name}.r${builtins.toString self.revCount}.${self.shortRev}";
            #versionSuffix = ".${nixpkgs.lib.substring 0 8 (nixpkgs.lastModifiedDate or nixpkgs.lastModified or "19700101")}.r${revCount}-${nixpkgs.lib.substring 0 11 (nixpkgs.rev or "dirty")}";
          };
        };
        nix.registry.nixpkgs.flake = nixpkgs;
        nixpkgs.overlays = overlays;

        home-manager = {
          useGlobalPkgs = true;
          useUserPackages = true;
          extraSpecialArgs = {
            inherit inputs modules;
            enableGUI = true;
          };
        };
      };
    in
    {
      nixosConfigurations."winter" = lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          base
          home-manager.nixosModules.home-manager
          ./hosts/winter.nix
          secrets.nixosModules.winter
        ];
        specialArgs = {
          inherit inputs modules;
          enableGUI = true;
        };
      };

      packages.x86_64-linux = customPackages nixpkgs.legacyPackages.x86_64-linux;
    };
}
