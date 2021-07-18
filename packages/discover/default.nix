{ inputs
, python3Packages
, gtk3
, gobject-introspection
, wrapGAppsHook
, ...
}:
python3Packages.buildPythonApplication {
  pname = "discover-overlay";
  version = "1.0";
  src = inputs.discover;

  nativeBuildInputs = [
    wrapGAppsHook
  ];
  propagatedBuildInputs = with python3Packages; [
    gtk3
    gobject-introspection
    pygobject3
    websocket-client
    pyxdg
    requests
    python-pidfile
    pillow
  ];
}
