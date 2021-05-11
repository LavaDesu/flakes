{
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs/nixos-unstable"; };
    #secrets = { url = "git+ssh://git@github.com/LavaDesu/flakes-secrets.git"; };
    secrets = { url = "github:LavaDesu/flakes-secrets"; };
  };

  outputs = { self, nixpkgs, secrets }: {
    nixosConfigurations."winter" = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
          nix.registry.nixpkgs.flake = nixpkgs;
        }
        secrets.nixosModules.winter
        ./cfg/winter/main.nix
      ];
    };
  };
}
