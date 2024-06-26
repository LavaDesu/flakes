{ config, pkgs, ... }: {
  programs.mpv = {
    enable = true;
    package = pkgs.mpv-unwrapped.wrapper {
      mpv = pkgs.mpv-unwrapped;
      youtubeSupport = true;
      scripts = [ pkgs.mpvScripts.mpris ];
    };
  };
}
