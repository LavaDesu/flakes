{
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    #secrets = { url = "git+ssh://git@github.com/LavaDesu/flakes-secrets.git"; };
    secrets = { url = "github:LavaDesu/flakes-secrets"; };
  };

  outputs = { self, nixpkgs, secrets }: with nixpkgs.lib;
    let
      base = {
        system.configurationRevision = mkIf (self ? rev) self.rev;
        nix.registry.nixpkgs.flake = nixpkgs;
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
      nixosConfigurations."winter" = nixosSystem {
        system = "x86_64-linux";
        modules = [
          base
          secrets.nixosModules.winter
          ./cfg/winter/main.nix
        ];
        specialArgs = { inherit overlays; };
      };
    };
}
