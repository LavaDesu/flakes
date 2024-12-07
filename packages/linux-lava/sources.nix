{ fetchFromGitHub, inputs, lib }:
let
  version = "6.12.3";
  kernelHash = "1sr58vsh39hdwk0z27lg14isqwn4g8m4r7a8z2rsyhkfwlmmd8mi";
  kernelPatchHash = "1nb9zhvx5s701kl5kmfifw41si1wrg2iw9v7szz8z291prrf3s7i";

  mm = lib.versions.majorMinor version;
  tkgPatches = [
    "0002-clear-patches"
    "0003-glitched-base"
    "0003-glitched-eevdf-additions"
    "0003-glitched-cfs"
    "0007-v${mm}-fsync_legacy_via_futex_waitv"
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
