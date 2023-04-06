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
    theme = spicePkgs.themes.Dribbblish;
    colorScheme = "purple";

    enabledCustomApps = with spicePkgs.apps; [
      lyrics-plus
    ];
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle # shuffle+ (special characters are sanitized out of ext names)
      hidePodcasts

      fullAppDisplayMod
      skipStats
      songStats
      history
      hidePodcasts
      volumePercentage
    ];
  };

}
