{
  lib,
  mkShell,

  flutter,
  clang,
  cmake,
  ninja,
  pkg-config,

  atk,
  cairo,
  gdk-pixbuf,
  glib,
  gtk3,
  harfbuzz,
  libGL,
  pango,
  wayland,
  xorg,
}:
let
  makeIncludePath = lib.makeSearchPathOutput "include" "include";

  includePath = makeIncludePath [
    xorg.xorgproto
    xorg.libX11.dev
  ];
in mkShell {
  nativeBuildInputs = [
    flutter
    clang
    cmake
    ninja
    pkg-config
  ];

  C_INCLUDE_PATH = includePath;
  CPLUS_INCLUDE_PATH = includePath;

  LD_LIBRARY_PATH = lib.makeLibraryPath "/lib" [
    atk
    cairo
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libGL
    pango
    wayland
    xorg.libX11
  ];
}
