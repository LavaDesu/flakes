{
  inputs = {
    nixpkgs = { url = "github:NixOS/nixpkgs"; };
    home-manager = { url = "github:LavaDesu/home-manager/xsession-profilePath"; };
    secrets = { url = "github:LavaDesu/flakes-secrets"; };

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: with inputs;
    let
      base = {
        system.configurationRevision = nixpkgs.lib.mkIf (self ? rev) self.rev;
        nix.registry.nixpkgs.flake = nixpkgs;
        nixpkgs.overlays = builtins.attrValues overlays;
      };
      hm-base = {
        home-manager.useGlobalPkgs = true;
        home-manager.useUserPackages = true;
      };
      overlays = {
        discord = import ./overlays/discord.nix;
        linux = import ./overlays/linux.nix;
        material-icons = import ./overlays/material-icons.nix;
        picom = import ./overlays/picom.nix;
        polybar = import ./overlays/polybar.nix;
        transcrypt = import ./overlays/transcrypt.nix;
        winetricks = import ./overlays/winetricks.nix;
        wine-osu = import ./overlays/wine-osu.nix;
        xinit = import ./overlays/xinit.nix;
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
        specialArgs = { inherit overlays; };
      };

      packages.x86_64-linux =
        let
          pkgs = import nixpkgs {
            overlays = builtins.attrValues overlays;
            system = "x86_64-linux";
          };
        in {
          inherit (pkgs) linux-lava wine-osu;
        };
    };
}
