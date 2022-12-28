{ fetchFromGitHub, inputs, lib }:
let
  version = "6.1.1";
  kernelHash = "1ssxn81jfl0jf9brczfrrwd1f1vmf594jvhrs7zgcc54a5qg389c";
  kernelPatchHash = "0qmmg4lmz8qhbdc2k6lhavbfak2r64jr8ac16wvnm1x72jwcsil9";

  mm = lib.versions.majorMinor version;
  tkgPatches = [
    "0001-mm-Support-soft-dirty-flag-reset-for-VA-range"
    "0002-clear-patches"
    "0002-mm-Support-soft-dirty-flag-read-with-reset"
    "0003-glitched-base"
    "0003-glitched-cfs"
    "0003-glitched-cfs-additions"
    "0007-v${mm}-fsync1_via_futex_waitv"
    "0007-v${mm}-winesync"
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

  borePatch = {
    name = "bore-patch";
    patch = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/78e1cd84c173959e87cca10f648fbcfbb37fbad2/${mm}/sched/0001-bore.patch";
      sha256 = "10dfd15zhvkvlk29zqlmgxm99y3lbkjlilvrbrdl8rjcybs4gbws";
    };
  };
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
    borePatch
    (patch ./si-manual-clocking.patch)
    #(patch ./atomic-async-page-flips.patch)
    #(patch ./winesync-hotfix.patch)
  ]
  ++ builtins.map (name: {
    inherit name;
    patch = "${inputs.linux-tkg}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches;
}
