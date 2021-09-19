{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    neovim-nightly.url = "github:nix-community/neovim-nightly-overlay";
    secrets.url = "github:LavaDesu/flakes-secrets";

    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    neovim-nightly.inputs.nixpkgs.follows = "nixpkgs";

    nix-gaming.url = "github:fufexan/nix-gaming";
    powercord-overlay.url = "github:LavaDesu/powercord-overlay";
    powercord-overlay.inputs.nixpkgs.follows = "nixpkgs";

    # zsh plugins
    zsh-abbr = { url = "github:olets/zsh-abbr"; flake = false; };
    zsh-history-substring-search = { url = "github:zsh-users/zsh-history-substring-search"; flake = false; };
    fast-syntax-highlighting = { url = "github:zdharma/fast-syntax-highlighting"; flake = false; };
    pure = { url = "github:sindresorhus/pure"; flake = false; };

    # overlays
    discord-tokyonight = { url = "github:DanisDGK/zelk-customizations"; flake = false; };
    discover = { url = "github:trigg/Discover"; flake = false; };
    spotify-adblock = { url = "github:abba23/spotify-adblock"; flake = false; };
    tree-sitter-glimmer = { url = "github:alexlafroscia/tree-sitter-glimmer"; flake = false; };
    tree-sitter-jsonc = { url = "gitlab:WhyNotHugo/tree-sitter-jsonc"; flake = false; };

    # powercord plugins/themes
    better-status-indicators = { url = "github:griefmodz/better-status-indicators"; flake = false; };
    channel-typing = { url = "github:powercord-community/channel-typing"; flake = false; };
    discord-tweaks = { url = "github:NurMarvin/discord-tweaks"; flake = false; };
    fix-user-popouts = { url = "github:cyyynthia/fix-user-popouts"; flake = false; };
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

  outputs = { self, nixpkgs, home-manager, secrets, ... } @ inputs:
    let
      lib = nixpkgs.lib;

      getPaths = root: builtins.map
        (path: root + ("/" + path)) # Prepends root path
        (builtins.attrNames (builtins.readDir root)); # Reads root path

      modules =
        let
          getName = path: lib.removeSuffix ".nix" ( # Strip extension
            lib.last (                              # Gets the last part (filename)
              lib.splitString "/" (                 # Splits the path into components
                builtins.toString path              # Converts the path into a string
              )
            )
          );
          genModulePaths = basePath: builtins.listToAttrs (
            builtins.map (path: {
              name = getName path;
              value = path;
            }) (getPaths basePath)
          );
        in {
          user = genModulePaths ./modules/user;
          system = genModulePaths ./modules/system;
        };

      customPackages = pkgs:
        let
          callPackage = pkgs.callPackage;
        in {
          discord-tokyonight = callPackage ./packages/discord-tokyonight {};
          discover-overlay = callPackage ./packages/discover {};
          linux-lava = callPackage ./packages/linux-lava {};
          spotify-adblock = callPackage ./packages/spotify-adblock {};
          tree-sitter-glimmer = callPackage ./packages/tree-sitter-glimmer {};
          tree-sitter-jsonc = callPackage ./packages/tree-sitter-jsonc {};
          wine-osu = callPackage ./packages/wine-osu { inherit getPaths; };
        };

      overlays = [ (self: super: { inherit inputs; }) ] ++ (builtins.map
        (path: import path) # Imports path
        (builtins.filter
          (path: lib.hasSuffix ".nix" path) # Checks file extension
          (getPaths ./overlays)
        )
      ) ++ [(self: super: customPackages super)]
        ++ [inputs.neovim-nightly.overlay]
        ++ [inputs.powercord-overlay.overlay];

      mkSystem =
        if !(self ? rev) then throw "Dirty git tree detected." else
        name: arch: enableGUI: lib.nixosSystem {
          system = arch;
          modules = [
            home-manager.nixosModules.home-manager
            secrets.nixosModules.${name}
            (./hosts + "/${name}")
          ];
          specialArgs = { inherit inputs modules overlays enableGUI; };
        };
    in
    {
      nixosConfigurations."apricot" = mkSystem "apricot" "x86_64-linux" false;
      nixosConfigurations."winter" = mkSystem "winter" "x86_64-linux" true;

      packages.x86_64-linux = customPackages nixpkgs.legacyPackages.x86_64-linux;
    };
}
