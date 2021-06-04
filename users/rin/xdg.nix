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
  ];
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
}
