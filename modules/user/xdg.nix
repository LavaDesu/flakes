{ config, ... }:
let
  genMimes = mimeTypes: builtins.listToAttrs (
    builtins.map (mimeType: {
      name = mimeType;
      value = "firefox.desktop";
    }) mimeTypes
  );

  mimes = genMimes [
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/chrome"
    "text/html"
    "application/x-extension-htm"
    "application/x-extension-html"
    "application/x-extension-shtml"
    "application/xhtml+xml"
    "application/x-extension-xhtml"
    "application/x-extension-xht"
  ] // {
    "x-scheme-handler/tg" = "userapp-Kotatogram Desktop-CHJI40.desktop";
    "image/png" = "feh.desktop";
    "image/jpeg" = "feh.desktop";
  };
in {
  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps = {
      enable = true;

      associations.added = mimes;
      defaultApplications = mimes;
    };
  };

  # XXX: might need to be moved
  xdg.configFile."wgetrc".text = ''
    hsts-file = ${config.xdg.cacheHome}/wget-hsts
  '';
}
