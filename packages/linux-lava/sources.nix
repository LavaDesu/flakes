{ fetchFromGitHub, lib }:
let
  version = "5.13.13";
  kernelHash = "1nc9didbjlycs9h8xahny1gwl8m8clylybnza6gl663myfbslsrz";
  kernelPatchHash = "1f3wc6iak94wa05byjpl0bcyx4k7kkhp3p01d71gax1ysi0nwqnv";
  tkgRev = "e2d99fd98a7b55fedd80b5944189adf8a4b1e946";
  tkgHash = "1r0qwj13m0zj0wp5zs25zs56a43dsb60inmb1hisxpa7cz59x9m7";
  caculeRev = "c8a8d0d84a1337f87fe0a218c978a61e90874fa2";
  caculeHash = "04lbmyp8s0zl1jcl6ndi1yvmzs6xjwawmmq5dw1wpz5wja20wvj9";

  tkgPatches = [
    "0001-mm-Support-soft-dirty-flag-reset-for-VA-range"
    "0002-clear-patches"
    "0002-mm-Support-soft-dirty-flag-read-with-reset"
    #"0003-cacule-${mm}"
    "0003-glitched-base"
    "0003-glitched-cfs"
    "0007-v${mm}-fsync"
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
  caculeSrc = {
    name = "cacule";
    patch = builtins.fetchurl {
        url = "https://raw.githubusercontent.com/hamadmarri/cacule-cpu-scheduler/${caculeRev}/patches/CacULE/v${mm}/cacule-${mm}.patch";
        sha256 = caculeHash;
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
    caculeSrc
    (patch ./si-manual-clocking.patch)
  ]
  ++ builtins.map (name: {
    inherit name;
    patch = "${tkgSrc}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches;
}
