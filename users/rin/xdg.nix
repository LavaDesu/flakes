{ config, ... }:
let
  genFF = mimeTypes: builtins.listToAttrs (builtins.map (mimeType: {
    name = mimeType;
    value = "firefox.desktop";
  }) mimeTypes);

  ffMimes = genFF [
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

      associations.added = ffMimes;
      defaultApplications = ffMimes;
    };
  };
}
