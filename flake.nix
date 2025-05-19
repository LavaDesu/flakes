{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    nixpkgs-stable.url = "github:NixOS/nixpkgs/release-25.05";
    home-manager-stable.url = "github:nix-community/home-manager/release-25.05";
    home-manager-stable.inputs.nixpkgs.follows = "nixpkgs-stable";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    catppuccin.url = "github:catppuccin/nix/8eada392fd6571a747e1c5fc358dd61c14c8704e";
    catppuccin.inputs.nixpkgs.follows = "nixpkgs";
    catppuccin-palette = { url = "github:catppuccin/palette"; flake = false; };
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";
    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
    spicetify-nix.inputs.nixpkgs.follows = "nixpkgs";

    # services
    # hosts-blocklists = { url = "github:notracking/hosts-blocklists"; flake = false; };
    website = { url = "github:LavaDesu/lavadesu.github.io/master"; flake = false; };

    # zsh plugins
    zsh-abbr = { url = "git+https://github.com/olets/zsh-abbr?submodules=1"; flake = false; };
    zsh-history-substring-search = { url = "github:zsh-users/zsh-history-substring-search"; flake = false; };
    fast-syntax-highlighting = { url = "github:zdharma-continuum/fast-syntax-highlighting"; flake = false; };
    pure = { url = "github:sindresorhus/pure"; flake = false; };

    # overlays
    linux-tkg = { url = "github:Frogging-Family/linux-tkg"; flake = false; };
    nvim-treesitter = { url = "github:nvim-treesitter/nvim-treesitter"; flake = false; };
    spotify-adblock = { url = "github:abba23/spotify-adblock"; flake = false; };
    tree-sitter-jsonc = { url = "gitlab:WhyNotHugo/tree-sitter-jsonc"; flake = false; };
    wine-discord-ipc-bridge = { url = "github:0e4ef622/wine-discord-ipc-bridge"; flake = false; };
  };

  outputs = { self, agenix, catppuccin, nixpkgs, nixpkgs-stable, ... } @ inputs:
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
        nixpkgs: name: arch: extraModules: nixpkgs.lib.nixosSystem {
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
            inherit inputs;
            modules = import ./modules { lib = nixpkgs.lib; };
            gcSecrets = builtins.fromJSON (builtins.readFile "${self}/secrets.gcrypt/shared.json");
          };
        };
    in
    {
      nixosConfigurations."anemone" = mkSystem nixpkgs "anemone" "x86_64-linux" [];
      nixosConfigurations."dandelion" = mkSystem nixpkgs-stable "dandelion" "aarch64-linux" [];
      nixosConfigurations."hazel" = mkSystem nixpkgs-stable "hazel" "x86_64-linux" [];
      nixosConfigurations."hyacinth" = mkSystem nixpkgs "hyacinth" "x86_64-linux" [];

      packages."x86_64-linux" =
        let
          pkgs = import nixpkgs rec {
            overlays = patchOverlaysWithLinuxLava nixpkgs system;
            system = "x86_64-linux";
          };
        in
        {
          inherit (pkgs.me) linux-lava spotify-adblock;
          linux-lava-ccache = pkgs.me.linux-lava.override { useCcache = true; };
        };
    };
}
