{ config, inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
  colours = builtins.mapAttrs (_: colour: builtins.replaceStrings ["#"] [""] colour) config.catppuccin.hexcolors;
  accentColour = colours.${config.catppuccin.accent};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  programs.spicetify = {
    enable = true;
    alwaysEnableDevTools = true;
    theme = spicePkgs.themes.dribbblish;
    customColorScheme = {
      text               = colours.text;
      subtext            = colours.subtext1;
      sidebar-text       = colours.text;
      main               = colours.base;
      sidebar            = colours.mantle;
      player             = colours.base;
      card               = colours.base;
      shadow             = colours.mantle;
      selected-row       = colours.overlay2;
      button             = colours.overlay1;
      button-active      = colours.overlay2;
      button-disabled    = colours.overlay0;
      tab-active         = colours.surface0;
      notification       = colours.surface0;
      notification-error = colours.red;
      misc               = colours.surface1;
    };

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
