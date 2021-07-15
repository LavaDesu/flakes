{ fetchFromGitHub, lib }:
let
  version = "5.13.2";
  kernelHash = "1nc9didbjlycs9h8xahny1gwl8m8clylybnza6gl663myfbslsrz";
  kernelPatchHash = "1875yk06rfv3698dnxjwxrymba2zc38abim54rn80jk26kml79db";
  tkgRev = "1f9d4f458cfbd1a661fc973338e67477e0e9126c";
  tkgHash = "1jyc8vnhvfjq45gz93k50x1xsk772gbcm82i1d2jr36a562pskbc";

  tkgPatches = [
    "0001-mm-Support-soft-dirty-flag-reset-for-VA-range"
    "0002-clear-patches"
    "0002-mm-Support-soft-dirty-flag-read-with-reset"
    "0003-cacule-${mm}"
    "0003-glitched-base"
    "0003-glitched-cfs"
    #"0007-v${mm}-fsync"
    "0007-v${mm}-futex2_interface"
    "0007-v${mm}-winesync"
    "0012-misc-additions"
  ];


  patch = path: {
    name = "patch-${path}";
    patch = path;
  };
  tkgSrc = fetchFromGitHub {
    owner = "Frogging-Family";
    repo = "linux-tkg";
    rev = tkgRev;
    sha256 = tkgHash;
  };
  kernelPatchSrc = {
    name = "patch";
    patch = builtins.fetchurl {
      url = "https://cdn.kernel.org/pub/linux/kernel/v${lib.versions.major version}.x/patch-${version}.xz";
      sha256 = kernelPatchHash;
    };
  };

  mm = lib.versions.majorMinor version;
in {
  inherit version;

  src = builtins.fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v${lib.versions.major version}.x/linux-${mm}.tar.xz";
    sha256 = kernelHash;
  };

  kernelPatches = [
    kernelPatchSrc
    (patch ./si-manual-clocking.patch)
  ]
  ++ builtins.map (name: {
    inherit name;
    patch = "${tkgSrc}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches;
}
