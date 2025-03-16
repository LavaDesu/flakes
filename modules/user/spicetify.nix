{ config, inputs, pkgs, ... }:
let
  spicePkgs = inputs.spicetify-nix.legacyPackages.${pkgs.system};
in
{
  imports = [ inputs.spicetify-nix.homeManagerModules.spicetify ];

  programs.spicetify = {
    enable = true;
    theme = spicePkgs.themes.dribbblish // rec {
      src = pkgs.stdenvNoCC.mkDerivation {
        pname = "spicetify-dribbblish-catppuccin-patch";
        version = "1.0.0";
        dontUnpack = true;
        installPhase = let
          color_prev1 = builtins.replaceStrings ["#"] [""] config.catppuccin.hexcolors.overlay1;
          color_prev2 = builtins.replaceStrings ["#"] [""] config.catppuccin.hexcolors.overlay2;
          color_next = builtins.replaceStrings ["#"] [""] config.catppuccin.hexcolors.${config.catppuccin.accent};
          color_sidebar_prev = builtins.replaceStrings ["#"] [""] config.catppuccin.hexcolors.mantle;
          color_sidebar_next = builtins.replaceStrings ["#"] [""] config.catppuccin.hexcolors.crust;
        in ''
          cp -r ${spicePkgs.themes.dribbblish.src} $out
          substituteInPlace $out/color.ini \
            --replace-fail "${color_prev1}" "${color_next}" \
            --replace-fail "${color_prev2}" "${color_next}" \
            --replace-fail "sidebar            = ${color_sidebar_prev}" \
                           "sidebar            = ${color_sidebar_next}"
        '';
      };
    };
    colorScheme = "catppuccin-${config.catppuccin.flavor}";

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
