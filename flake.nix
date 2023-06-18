{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/44acd64171d440c3d91709a194bf35d6461e16c4";
    nixpkgs-raccoon.url = "github:NixOS/nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager-raccoon.url = "github:nix-community/home-manager/release-22.11";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    nixos-generators.url = "github:nix-community/nixos-generators";
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    agenix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-raccoon.inputs.nixpkgs.follows = "nixpkgs-raccoon";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";

    # services
    hosts-blocklists = { url = "github:notracking/hosts-blocklists"; flake = false; };
    website = { url = "github:LavaDesu/lavadesu.github.io/master"; flake = false; };

    # zsh plugins
    zsh-abbr = { url = "github:olets/zsh-abbr"; flake = false; };
    zsh-history-substring-search = { url = "github:zsh-users/zsh-history-substring-search"; flake = false; };
    fast-syntax-highlighting = { url = "github:zdharma-continuum/fast-syntax-highlighting"; flake = false; };
    pure = { url = "github:sindresorhus/pure"; flake = false; };

    # overlays
    discord-tokyonight = { url = "github:DanisDGK/zelk-customizations"; flake = false; };
    discover = { url = "github:trigg/Discover"; flake = false; };
    linux-tkg = { url = "github:Frogging-Family/linux-tkg"; flake = false; };
    nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
    packwiz = { url = "github:comp500/packwiz"; flake = false; };
    spotify-adblock = { url = "github:abba23/spotify-adblock"; flake = false; };
    tree-sitter-glimmer = { url = "github:alexlafroscia/tree-sitter-glimmer"; flake = false; };
    tree-sitter-jsonc = { url = "gitlab:WhyNotHugo/tree-sitter-jsonc"; flake = false; };
    wine-discord-ipc-bridge = { url = "github:0e4ef622/wine-discord-ipc-bridge"; flake = false; };

    # shells
    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, agenix, nixos-generators, nixpkgs, nixpkgs-raccoon, ... } @ inputs:
    let
      overlays = (import ./overlays)
        ++ [(final: prev: {
          me = prev.callPackage ./packages { inherit inputs; } // { inherit inputs; };
        })];

      mkSystem =
        if !(self ? rev) then throw "Dirty git tree detected." else
        nixpkgs: name: arch: enableGUI: extraModules: nixpkgs.lib.nixosSystem {
          system = arch;
          modules = [
            { nixpkgs.overlays = overlays; }
            agenix.nixosModules.age
            (./hosts + "/${name}")
          ] ++ extraModules;
          specialArgs = {
            inherit inputs enableGUI;
            modules = import ./modules { lib = nixpkgs.lib; };
          };
        };
    in
    {
      nixosConfigurations."blossom" = mkSystem nixpkgs "blossom" "x86_64-linux" true [];
      nixosConfigurations."hyacinth" = mkSystem nixpkgs "hyacinth" "x86_64-linux" true [];

      nixosConfigurations."caramel" = mkSystem nixpkgs-raccoon "caramel" "aarch64-linux" false [{
        nixpkgs.overlays = [
          (self: super: {
            makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
          })
        ];
      }];
      nixosConfigurations."sugarcane" = mkSystem nixpkgs-raccoon "sugarcane" "x86_64-linux" false [];

      packages."x86_64-linux" =
        let
          pkgs = import nixpkgs {
            inherit overlays;
            system = "x86_64-linux";
          };
        in
        {
          inherit (pkgs.me) linux-lava;
        };

      packages."aarch64-linux" =
        let
          pkgs = import nixpkgs-raccoon {
            inherit overlays;
            system = "aarch64-linux";
          };
        in
        {
          caramel-img = self.nixosConfigurations."caramel".config.system.build.sdImage;
        };

      # TODO: currently broken
      # devShells.x86_64-linux = pkgs.callPackage ./shells { inherit inputs; };
    };
}
