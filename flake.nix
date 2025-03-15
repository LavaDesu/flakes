{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-raccoon.url = "github:NixOS/nixpkgs/nixos-22.11";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager-raccoon.url = "github:nix-community/home-manager/release-22.11";
    home-manager-stable.url = "github:nix-community/home-manager/release-23.11";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    nixos-generators.url = "github:nix-community/nixos-generators";
    spicetify-nix.url = "github:the-argus/spicetify-nix";

    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin.url = "github:catppuccin/nix/8eada392fd6571a747e1c5fc358dd61c14c8704e";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin-palette = { url = "github:catppuccin/palette"; flake = false; };
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-raccoon.inputs.nixpkgs.follows = "nixpkgs-raccoon";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";

    # services
    hosts-blocklists = { url = "github:notracking/hosts-blocklists"; flake = false; };
    website = { url = "github:LavaDesu/lavadesu.github.io/master"; flake = false; };
    spicetify-themes = { url = "github:spicetify/spicetify-themes"; flake = false; };

    # zsh plugins
    zsh-abbr = { url = "git+https://github.com/olets/zsh-abbr?submodules=1"; flake = false; };
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

  outputs = { self, agenix, catppuccin, nixos-generators, nixpkgs, nixpkgs-raccoon, nixpkgs-stable, ... } @ inputs:
    let
      overlays = (import ./overlays)
        ++ [(final: prev: {
          me = prev.callPackage ./packages { inherit inputs; } // { inherit inputs; };
        })];

        patchOverlaysWithLinuxLava = nixpkgs: arch: ([(self: super: {
          linuxLavaNixpkgs = import nixpkgs {
            overlays = [ (import ./overlays/linux-lava.nix) ] ++ overlays;
            system = arch;
          };
        })] ++ overlays);

      mkSystem =
        if !(self ? rev) then throw "Dirty git tree detected." else
        nixpkgs: name: arch: enableGUI: extraModules: nixpkgs.lib.nixosSystem {
          system = arch;
          modules = [
            ({
              nixpkgs.overlays = patchOverlaysWithLinuxLava nixpkgs arch;
            })
            agenix.nixosModules.age
            catppuccin.nixosModules.catppuccin
            (./hosts + "/${name}")
          ] ++ extraModules;
          specialArgs = {
            inherit inputs enableGUI;
            modules = import ./modules { lib = nixpkgs.lib; };
          };
        };
    in
    {
      nixosConfigurations."anemone" = mkSystem nixpkgs "anemone" "x86_64-linux" true [];
      nixosConfigurations."hyacinth" = mkSystem nixpkgs "hyacinth" "x86_64-linux" true [];

      packages."x86_64-linux" =
        let
          pkgs = import nixpkgs rec {
            overlays = patchOverlaysWithLinuxLava nixpkgs system;
            system = "x86_64-linux";
          };
        in
        {
          inherit (pkgs.me) linux-lava spotify-adblock;
        };

      packages."aarch64-linux" =
        let
          pkgs = import nixpkgs-raccoon {
            inherit overlays;
            system = "aarch64-linux";
          };
        in
        {
        };

      # TODO: currently broken
      # devShells.x86_64-linux = pkgs.callPackage ./shells { inherit inputs; };
    };
}
