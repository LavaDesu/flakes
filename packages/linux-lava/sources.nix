{ fetchFromGitHub, inputs, lib }:
let
  version = "6.9.3";
  kernelHash = "0jc14s7z2581qgd82lww25p7c4w72scpf49z8ll3wylwk3xh3yi4";
  kernelPatchHash = "1lzkpyp41175kf672s92bz7wzx0favy5xdmxpsgzl9s3z6hdyb7q";

  mm = lib.versions.majorMinor version;
  tkgPatches = [
    "0002-clear-patches"
    "0003-glitched-base"
    "0003-glitched-eevdf-additions"
    "0003-glitched-cfs"
    "0007-v${mm}-fsync1_via_futex_waitv"
    "0007-v${mm}-ntsync"
#   "0007-v${mm}-winesync" fails to patch
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
