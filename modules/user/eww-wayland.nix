{ config, pkgs, ... }:
let
  res = pkgs.stdenvNoCC.mkDerivation {
    pname = "eww-wayland-config";
    version = "1.0.0";
    dontUnpack = true;
    installPhase = ''
      cp -r ${../../res/eww-wayland} $out
      substituteInPlace $out/eww.scss \
        --replace-warn "EWW_BACKGROUND" "${config.catppuccin.hexcolors.surface0}" \
        --replace-warn "EWW_TEXT" "${config.catppuccin.hexcolors.text}" \
        --replace-warn "EWW_ACCENT" "${config.catppuccin.hexcolors.pink}"
    '';
  };
in {
  home.packages = with pkgs; [ socat ];
  programs.eww = {
    enable = true;
    configDir = res;
  };
}
