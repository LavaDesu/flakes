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
        picom = import ./overlays/picom.nix;
        polybar = import ./overlays/polybar.nix;
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
