{ fetchFromGitHub, inputs, lib }:
let
  version = "5.17.2";
  kernelHash = "1cdi43x4c3l4chznh57gm55szycj4wjlxl1dss1ilnfvvmhyypsm";
  kernelPatchHash = "0rsril9dpvxy4afc6agx8gsyhmbicww43dzmjhmxa8c4h6wdj8bx";

  tkgPatches = [
    "0001-mm-Support-soft-dirty-flag-reset-for-VA-range"
    "0002-clear-patches"
    "0002-mm-Support-soft-dirty-flag-read-with-reset"
    "0003-glitched-base"
    "0007-v${mm}-fsync1_via_futex_waitv"
    "0007-v${mm}-winesync"
    "0009-prjc_v5.17-r0"
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
