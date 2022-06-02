{ fetchFromGitHub, inputs, lib }:
let
  version = "5.18.1";
  kernelHash = "1vjwhl4s8qxfg1aabn8xnpjza3qzrjcp5450h9qpjvl999lg3wsi";
  kernelPatchHash = "1kppzbm3i8r6i7fqlfw1i2q4dly2qxr755abhvh5r0r4wrlj8alm";

  tkgPatches = [
    "0001-mm-Support-soft-dirty-flag-reset-for-VA-range"
    "0002-clear-patches"
    "0002-mm-Support-soft-dirty-flag-read-with-reset"
    "0003-glitched-base"
    "0007-v${mm}-fsync1_via_futex_waitv"
    "0007-v${mm}-winesync"
    "0009-prjc_v${mm}-r1"
    "0009-glitched-ondemand-bmq"
    "0005-glitched-pds"
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
  mm = lib.versions.majorMinor version;
in {
  inherit version;

  # src = builtins.fetchurl {
  #   url = "https://git.kernel.org/torvalds/t/linux-${mm}${rc}.tar.gz";
  #   sha256 = kernelHash;
  # };
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
    patch = "${inputs.linux-tkg}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches;
}
