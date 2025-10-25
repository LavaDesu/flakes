{ config, pkgs, ... }:
let
  theme = pkgs.stdenvNoCC.mkDerivation {
    pname = "rofi-theme";
    version = "1.0.0";
    dontUnpack = true;
    installPhase = ''
      cp ${../../res/theme.rasi} $out
      substituteInPlace $out \
        --replace-fail "CAT_BACKGROUND" "${config.catppuccin.hexcolors.crust}" \
        --replace-fail "CAT_TEXT" "${config.catppuccin.hexcolors.text}" \
        --replace-fail "CAT_ACCENT" "${config.catppuccin.hexcolors.${config.catppuccin.accent}}" \
        --replace-fail "CAT_PLACEHOLDER" "${config.catppuccin.hexcolors.overlay1}"
    '';
  };
in {
  programs.rofi = {
    enable = true;
    theme = "theme";
  };
  xdg.configFile."rofi/theme.rasi".source = theme;
}
