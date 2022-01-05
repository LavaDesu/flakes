# Copied from https://github.com/NixOS/nixpkgs/pull/146940

{ stdenv
, lib
, fetchurl
, autoPatchelfHook
, alsa-lib
, cups
, libX11
, libXScrnSaver
, libXtst
, mesa
, nss
, systemd
, wrapGAppsHook
}:

stdenv.mkDerivation rec {
  pname = "tetrio-desktop";
  version = "8.0.0";

  src = fetchurl {
    url = "https://web.archive.org/web/20211228025517/https://tetr.io/about/desktop/builds/TETR.IO%20Setup.deb";
    name = "${pname}.deb";
    sha256 = "1nlblfhrph4cw8rpic9icrs78mzrxyskl7ggyy2i8bk9i07i21xf";
  };

  nativeBuildInputs = [
    alsa-lib
    autoPatchelfHook
    cups
    libX11
    libXScrnSaver
    libXtst
    mesa
    nss
    wrapGAppsHook
  ];

  dontWrapGApps = true;

  libPath = lib.makeLibraryPath [
    alsa-lib
    cups
    libX11
    libXScrnSaver
    libXtst
    mesa
    nss
    systemd
  ];

  unpackPhase = ''
    mkdir -p $TMP/${pname} $out/bin
    cp $src $TMP/${pname}.deb
    ar vx $TMP/${pname}.deb
    tar --no-overwrite-dir -xvf data.tar.xz -C $TMP/${pname}/
  '';

  installPhase = ''
    cp -R $TMP/${pname}/{usr/share,opt} $out/
    wrapProgram $out/opt/TETR.IO/${pname} \
      --prefix LD_LIBRARY_PATH : ${libPath}:$out/opt/TETR.IO
    ln -s $out/opt/TETR.IO/${pname} $out/bin/
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace "Exec=\"/opt/TETR.IO/${pname}\"" "Exec=\"$out/opt/TETR.IO/${pname}\""
  '';

  meta = with lib; {
    homepage = "https://tetr.io";
    downloadPage = "https://tetr.io/about/desktop/";
    description = "TETR.IO desktop client";
    longDescription = ''
      TETR.IO is a modern yet familiar online stacker.
      Play against friends and foes all over the world, or claim a spot on the leaderboards - the stacker future is yours!
    '';
    platforms = [ "x86_64-linux" ];
    license = licenses.unfree;
    #maintainers = with maintainers; [ wackbyte ];
  };
}
