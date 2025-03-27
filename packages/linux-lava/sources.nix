{ fetchFromGitHub, inputs, lib }:
let
  version = "6.14";
  kernelHash = "0w3nqh02vl8f2wsx3fmsvw1pdsnjs5zfqcmv2w2vnqdiwy1vd552";
  kernelPatchHash = "0vv8njki6gbkzdsvmbhf6lr3i6ipnyf88xzxkk0cx8f4gc63rl9g";

  mm = lib.versions.majorMinor version;
  hasPatch = (builtins.length (builtins.splitVersion version)) == 3;
  tkgPatches = [
    "0002-clear-patches"
    "0003-glitched-base"
    "0003-glitched-eevdf-additions"
    "0003-glitched-cfs"
    "0007-v${mm}-fsync_legacy_via_futex_waitv"
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

  kernelPatches = lib.optionals hasPatch [
    kernelPatchSrc
  ]
  ++ builtins.map (name: {
    inherit name;
    patch = "${inputs.linux-tkg}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches
  ++ [ ];
}
