{ fetchFromGitHub, lib }:
let
  version = "5.13.0";
  kernelHash = "1nc9didbjlycs9h8xahny1gwl8m8clylybnza6gl663myfbslsrz";
  kernelPatchHash = "";
  tkgRev = "1137522351b2044de4ac9edc6675b3dcb3de504a";
  tkgHash = "118hvwjjc71gh8jsyswpbap90fmqczcknxdf7bvyn7cgacaix7bq";

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
  mm = lib.versions.majorMinor version;
in {
  inherit version;

  src = builtins.fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v${lib.versions.major version}.x/linux-${mm}.tar.xz";
    sha256 = kernelHash;
  };

  kernelPatches = [(patch ./si-manual-clocking.patch)]
  # ++ [(builtins.fetchurl {
  #   url = "https://cdn.kernel.org/pub/linux/kernel/v${lib.versions.major version}.x/patch${version}.xz";
  #   sha256 = kernelPatchHash;
  # })]
  ++ builtins.map (name: {
    inherit name;
    patch = "${tkgSrc}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches;
}
