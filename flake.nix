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
      hm-module = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
        home-manager.users.rin = import ./cfg/winter/rin/home.nix; # TODO: decoupling
      };
      overlays = {
        linux = import ./overlays/linux.nix;
        picom = import ./overlays/picom.nix;
        polybar = import ./overlays/polybar.nix;
        discord = (self: super: {
          discord-canary = super.discord-canary.override rec {
            version = "0.0.121";
            src = builtins.fetchurl {
              url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
              sha256 = "0s85nh31wv39adawfmllp128n0wgyisbi604n0cngzi28rdw7bph";
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
          ./cfg/winter
          home-manager.nixosModules.home-manager hm-module
          secrets.nixosModules.winter
        ];
        specialArgs = { inherit inputs overlays; };
      };
    };
}
