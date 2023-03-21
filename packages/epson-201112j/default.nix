{ lib, stdenv, fetchurl, rpmextract, autoreconfHook, file, libjpeg, cups }:

let
  version = "1.0.0";
  filterVersion = "1.0.0";
in
  stdenv.mkDerivation {
    pname = "epson-201112j";
    inherit version;

    src = fetchurl {
      # NOTE: Don't forget to update the webarchive link too!
      urls = [
        "http://download.ebz.epson.net/dsc/f/01/00/01/68/36/cbf6cf36263b5a6c4f370266f2479556cd665d7c/epson-inkjet-printer-201112j-${version}-1lsb3.2.src.rpm"
      ];

      sha256 = "sha256-+n5QQDMgEjKYFlH62bVAZRtr0GjyG8yDahPquOjIZWA=";
    };

    nativeBuildInputs = [ rpmextract autoreconfHook file ];

    buildInputs = [ libjpeg cups ];

    unpackPhase = ''
      rpmextract $src
      tar -zxf epson-inkjet-printer-201112j-${version}.tar.gz
      tar -zxf epson-inkjet-printer-filter-${filterVersion}.tar.gz
      for ppd in epson-inkjet-printer-201112j-${version}/ppds/*; do
        substituteInPlace $ppd --replace "/opt/epson-inkjet-printer-201112j" "$out"
        substituteInPlace $ppd --replace "/cups/lib" "/lib/cups"
      done
      cd epson-inkjet-printer-filter-${filterVersion}
    '';

    preConfigure = ''
      chmod +x configure
      export LDFLAGS="$LDFLAGS -Wl,--no-as-needed"
    '';

    postInstall = ''
      cd ../epson-inkjet-printer-201112j-${version}
      cp -a lib64 resource watermark $out
      mkdir -p $out/share/cups/model/epson-inkjet-printer-201112j
      cp -a ppds $out/share/cups/model/epson-inkjet-printer-201112j/
      cp -a Manual.txt $out/doc/
      cp -a README $out/doc/README.driver
    '';

    meta = with lib; {
      homepage = "https://www.openprinting.org/driver/epson-201112j";
      description = "Epson printer driver (BX535WD, BX630FW, BX635FWD, ME940FW, NX530, NX635, NX635, SX535WD, WorkForce 545, WorkForce 645";
      longDescription = ''
        This software is a filter program used with the Common UNIX Printing
        System (CUPS) under Linux. It supplies high quality printing with
        Seiko Epson Color Ink Jet Printers.
        List of printers supported by this package:
          Epson BX535WD Series
          Epson BX630FW Series
          Epson BX635FWD Series
          Epson ME940FW Series
          Epson NX530 Series
          Epson SX535WD Series
          Epson WorkForce 545 Series
          Epson WorkForce 645 Series
        To use the driver adjust your configuration.nix file:
          services.printing = {
            enable = true;
            drivers = [ pkgs.epson-201112j ];
          };
      '';
      license = with licenses; [ lgpl21 epson ];
      platforms = platforms.linux;
      maintainers = [];
    };
  }
