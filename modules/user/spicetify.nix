{ config, inputs, lib, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  programs.spicetify = {
    enable = true;
    alwaysEnableDevTools = true;
    theme = spicePkgs.themes.catppuccin // {
      additionalCss = ''
        /* Removes "About the artist" text in now playing menu */
        .main-nowPlayingView-sectionHeaderText {
          display: none;
        }

        /* Removes gradient in now playing menu */
        .main-nowPlayingView-contextItemInfo:before {
          background: none;
        }

        /* Removes gradient above artist image */
        /* https://stackoverflow.com/a/77015731 < this is so smart */
        .main-nowPlayingView-aboutArtistV2ImageContainer.main-nowPlayingView-aboutArtistV2Image {
          background-size: 0% 0%, cover;
        }
      '';
    };
    colorScheme = config.catppuccin.flavor;

    enabledSnippets = with spicePkgs.snippets; [
      removeGradient
    ];
    enabledCustomApps = with spicePkgs.apps; [
      lyricsPlus
    ];
    enabledExtensions = with spicePkgs.extensions; [
      fullAppDisplay
      shuffle
      hidePodcasts

      skipStats
      songStats
      history
      volumePercentage
    ];
  };

  home.file.".local/bin/spotify".source = lib.getExe config.programs.spicetify.spicedSpotify;
}
