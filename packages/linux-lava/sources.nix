{ fetchFromGitHub, lib }:
let
  version = "5.13.4";
  kernelHash = "1nc9didbjlycs9h8xahny1gwl8m8clylybnza6gl663myfbslsrz";
  kernelPatchHash = "0yvp4z2m6f0sx7kvkbijaqf1x4k0fwk5rk05q612xzmm4cp85ik6";
  tkgRev = "c50061015feb38e0a098e3b7c58d71e225fe7498";
  tkgHash = "0ibkfr3ijl6xa2vcx4w6dmy15n76lh8ksia4bafzj9nz5a65my26";

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
