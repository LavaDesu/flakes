{ fetchFromGitHub, inputs, lib }:
let
  version = "5.15.13";
  kernelHash = "1s0yk78kilcr3vd14k67cmllnrx0x0i00jdkl5kkn3lij5lwzcjp";
  kernelPatchHash = "044y7mmla0f73mky24vpvl8ba3warfr6im97s1231gjxican40v6";

  tkgPatches = [
    "0001-mm-Support-soft-dirty-flag-reset-for-VA-range"
    "0002-clear-patches"
    "0002-mm-Support-soft-dirty-flag-read-with-reset"
    "0003-glitched-base"
    "0007-v${mm}-futex_waitv"
    "0007-v${mm}-fsync1_via_futex_waitv"
    "0007-v${mm}-winesync"
    "0009-prjc_v5.15-r1"
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

  src = builtins.fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v${lib.versions.major version}.x/linux-${mm}.tar.xz";
    sha256 = kernelHash;
  };

  kernelPatches = [
    # This is dumb but nix strips FHS paths *before* patching (why???????) so patches might fail to apply
    # This "unpatch patch" fixes one such patch failure, then reapplys the stripped FHS path in
    # the "repatch patch" (even though the affected file isn't really used but w/e)
    (patch ./unpatch.patch)
    kernelPatchSrc
    (patch ./repatch.patch)
    (patch ./si-manual-clocking.patch)
  ]
  ++ builtins.map (name: {
    inherit name;
    patch = "${inputs.linux-tkg}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches;
}
