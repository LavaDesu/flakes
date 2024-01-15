{ fetchFromGitHub, inputs, lib }:
let
  version = "6.7.0";
  kernelHash = "0s8hbcsg7fdvspqam8kzcxygjsznr4zfi60nqgc81l3n4m518cgg";
  kernelPatchHash = "1qnial7m91l3amcsgms3cs599pi529kvda1c982qk45s39y029xj";

  mm = lib.versions.majorMinor version;
  tkgPatches = [
    "0002-clear-patches"
    "0003-glitched-base"
    "0003-glitched-eevdf-additions"
    "0003-glitched-cfs"
    "0007-v${mm}-fsync1_via_futex_waitv"
#    "0007-v${mm}-winesync" currently fails to patch
    "0012-misc-additions"
  ];

  patch = path: {
    name = "patch-${path}";
    patch = path;
  };
  kernelPatchSrc = {
    name = "patch";
    patch = builtins.fetchurl {
      url = "https://cdn.kernel.org/pub/linux/kernel/v${lib.versions.major version}.x/patch-${version}.xz";
      sha256 = kernelPatchHash;
    };
  };
in {
  inherit version;

  src = builtins.fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v${lib.versions.major version}.x/linux-${mm}.tar.xz";
    sha256 = kernelHash;
  };

  kernelPatches = [
    #kernelPatchSrc
  ]
  ++ builtins.map (name: {
    inherit name;
    patch = "${inputs.linux-tkg}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches
  ++ [
  ];
}
