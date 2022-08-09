{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    nixpkgs-porcupine.url = "github:NixOS/nixpkgs/nixos-21.11";
    home-manager.url = "github:nix-community/home-manager";
    home-manager-porcupine.url = "github:LavaDesu/home-manager/backport/gpg-agent";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    agenix.url = "github:ryantm/agenix";
    nixos-generators.url = "github:nix-community/nixos-generators";

    agenix.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    home-manager-porcupine.inputs.nixpkgs.follows = "nixpkgs-porcupine";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs-porcupine";

    nix-gaming.url = "github:fufexan/nix-gaming";
    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    powercord-overlay.inputs.nixpkgs.follows = "nixpkgs";

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

    # powercord plugins/themes
    better-status-indicators = { url = "github:griefmodz/better-status-indicators"; flake = false; };
    channel-typing = { url = "github:powercord-community/channel-typing"; flake = false; };
    discord-tweaks = { url = "github:NurMarvin/discord-tweaks"; flake = false; };
    fix-user-popouts = { url = "github:cyyynthia/fix-user-popouts"; flake = false; };
    multitask = { url = "github:powercord-community/multitask"; flake = false; };
    no-double-back-pc = { url = "github:the-cord-plug/no-double-back-pc"; flake = false; };
    powercord-popout-fix = { url = "github:Nexure/PowerCord-Popout-Fix"; flake = false; };
    rolecolor-everywhere = { url = "github:powercord-community/rolecolor-everywhere"; flake = false; };
    theme-toggler = { url = "github:redstonekasi/theme-toggler"; flake = false; };
    twemoji-but-good = { url = "github:powercord-community/twemoji-but-good"; flake = false; };
    view-raw = { url = "github:Juby210/view-raw"; flake = false; };
    who-reacted = { url = "github:jaimeadf/who-reacted"; flake = false; };

    radialstatus = { url = "github:DiscordStyles/RadialStatus"; flake = false; };
    tokyonight = { url = "github:Dyzean/Tokyo-Night"; flake = false; };
    zelk = { url = "github:schnensch0/zelk"; flake = false; };
  };

  outputs = { self, agenix, nixos-generators, nixpkgs, nixpkgs-porcupine, ... } @ inputs:
    let
      overlays = (import ./overlays)
        ++ [inputs.powercord-overlay.overlay]
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

      nixosConfigurations."caramel" = mkSystem nixpkgs-porcupine "caramel" "aarch64-linux" false [{
        nixpkgs.overlays = [
          (self: super: {
            makeModulesClosure = x: super.makeModulesClosure (x // { allowMissing = true; });
          })
        ];
      }];
      nixosConfigurations."sugarcane" = mkSystem nixpkgs-porcupine "sugarcane" "x86_64-linux" false [];

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
          pkgs = import nixpkgs-porcupine {
            overlays = overlays ++ [
              # See https://github.com/NixOS/nixpkgs/issues/126755#issuecomment-869149243
            ];
            system = "aarch64-linux";
          };
        in
        {
          inherit (pkgs) nixUnstable;

          caramel-iso2 = self.nixosConfigurations."caramel".config.system.build.sdImage;
          caramel-iso = nixos-generators.nixosGenerate {
            inherit pkgs;
            format = "sd-aarch64";
            modules = [
              agenix.nixosModules.age
              ./hosts/caramel
            ];
            specialArgs = {
              inherit inputs;
              modules = import ./modules { lib = nixpkgs-porcupine.lib; };
            };
          };
        };

      # TODO: currently broken
      # devShells.x86_64-linux = pkgs.callPackage ./shells { inherit inputs; };
    };
}
