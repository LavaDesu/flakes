{ config, ... }:
let
  genMimes = mimeTypes: builtins.listToAttrs (builtins.map (mimeType: {
    name = mimeType;
    value = "brave-browser.desktop";
  }) mimeTypes);

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
    # XXX: this thing found it unwritable so it just deletes it and rewrite???
    "x-scheme-handler/tg" = "userapp-Kotatogram Desktop-CHJI40.desktop";
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
