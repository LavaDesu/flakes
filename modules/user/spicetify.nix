{ config, inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.packages.${pkgs.system}.default;
  #adblock = inputs.spotify-adblock.defaultPackage.x86_64-linux;
  adblock = pkgs.me.spotify-adblock;
in
{
  imports = [ inputs.spicetify-nix.homeManagerModule ];

  programs.spicetify = {
    spotifyPackage = pkgs.spotify-unwrapped.overrideAttrs(o: {
      installPhase = pkgs.lib.replaceStrings ["--prefix PATH"] [
        ''--prefix SPOTIFY_ADBLOCK_CONFIG : ${adblock}/lib/config.toml \
          --prefix LD_PRELOAD : ${adblock}/lib/libspotifyadblock.so \
          --prefix PATH''] o.installPhase;
    });

    enable = true;
    theme = spicePkgs.themes.Dribbblish // {
      #src = inputs.spicetify-themes;
      extraCommands = "spicetify-cli --no-restart config experimental_features 1";
      #requiredExtensions = [((builtins.head spicePkgs.themes.Dribbblish.requiredExtensions) // { filename = "theme.js"; }) ];
    };
    colorScheme = "purple";

    enabledCustomApps = with spicePkgs.apps; [
      lyrics-plus
    ];
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplayMod
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      hidePodcasts

      skipStats
      songStats
      history
      volumePercentage
    ];
  };
}
