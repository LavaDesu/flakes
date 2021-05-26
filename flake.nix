{
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    home-manager = { url = "github:nix-community/home-manager"; };
    secrets = { url = "github:LavaDesu/flakes-secrets"; };

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: with inputs;
    let
      base = {
        system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        nix.registry.nixpkgs.flake = nixpkgs;
      };
      hm-base = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      };
      overlays = {
        linux = import ./overlays/linux.nix;
        picom = import ./overlays/picom.nix;
        polybar = import ./overlays/polybar.nix;
        winetricks = import ./overlays/winetricks.nix;
        discord = (self: super: {
          discord-canary = super.discord-canary.override rec {
            version = "0.0.123";
            src = builtins.fetchurl {
              url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
              sha256 = "0bijwfsd9s4awqkgxd9c2cxh7y5r06vix98qjp0dkv63r6jig8ch";
            };
          };
        });
        wine-osu = import ./overlays/wine-osu.nix;
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
        specialArgs = { inherit inputs overlays; };
      };
    };
}
