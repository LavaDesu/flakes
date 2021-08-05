{ fetchFromGitHub, lib }:
let
  version = "5.13.8";
  kernelHash = "1nc9didbjlycs9h8xahny1gwl8m8clylybnza6gl663myfbslsrz";
  kernelPatchHash = "0vb17vjgqdkblb53bjpg8hlqs6wnm9h78ndbx3xj346n5hqszfnz";
  tkgRev = "dd79616e3828786635443b8f83d1ecaa7a2c1e94";
  tkgHash = "0afbrv6j9r4zlhpfqvp8i8c4ghfcb1a976b0h3rv7304gyzdnhlr";

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
