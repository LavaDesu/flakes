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
            inherit inputs;
            enableGUI = true;
          };
        };
      };
    in
    {
      nixosConfigurations."winter" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          base
          home-manager.nixosModules.home-manager
          ./hosts/winter
          secrets.nixosModules.winter
        ];
        specialArgs = {
          inherit inputs;
          enableGUI = true;
        };
      };

      packages.x86_64-linux = customPackages nixpkgs.legacyPackages.x86_64-linux;
    };
}
