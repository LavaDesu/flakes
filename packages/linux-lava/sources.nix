{ fetchFromGitHub, inputs, lib }:
let
  version = "6.13.7";
  kernelHash = "0vhdz1as27kxav81rkf6fm85sqrbj5hjhz5hpyxcd5b6p1pcr7g7";
  kernelPatchHash = "0akxqc8fdf6gkiy967crp7m1ikidd3rlhx804y3da1jl75dgqcrw";

  mm = lib.versions.majorMinor version;
  tkgPatches = [
    "0002-clear-patches"
    "0003-glitched-base"
    "0003-glitched-eevdf-additions"
    "0003-glitched-cfs"
    "0007-v${mm}-fsync_legacy_via_futex_waitv"
    "0007-v${mm}-ntsync"
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
    kernelPatchSrc
  ]
  ++ builtins.map (name: {
    inherit name;
    patch = "${inputs.linux-tkg}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches
  ++ [ ];
}
