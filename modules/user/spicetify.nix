{ config, inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  programs.spicetify = {
    enable = true;
    alwaysEnableDevTools = true;
    theme = spicePkgs.themes.catppuccin;
    colorScheme = config.catppuccin.flavor;

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
}
