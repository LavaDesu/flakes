{ fetchFromGitHub, inputs, lib }:
let
  version = "6.0.0";
  kernelHash = "13kqh7yhifwz5dmd3ky0b3mzbh9r0nmjfp5mxy42drcdafjl692w";
  #kernelPatchHash = "0y25zs7rlk9dz9ppyr76rv6id64j3f4hpby4wljmy7p9z9wba30s";

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
    "0010-lru_${mm}"
    "0012-misc-additions"
  ];

  patch = path: {
    name = "patch-${path}";
    patch = path;
  };
  # kernelPatchSrc = {
  #   name = "patch";
  #   patch = builtins.fetchurl {
  #     url = "https://cdn.kernel.org/pub/linux/kernel/v${lib.versions.major version}.x/patch-${version}.xz";
  #     sha256 = kernelPatchHash;
  #   };
  # };

  borePatch = {
    name = "bore-patch";
    patch = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/faaa50992e7ddea9191eb51920ffbf41226c9741/${mm}/sched/0001-bore.patch";
      sha256 = "1a3vypmrlr20fdvzshgqad3c64bh5hd4295p42j0260dz7vzbf7v";
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
    #kernelPatchSrc
    borePatch
    (patch ./si-manual-clocking.patch)
    (patch ./atomic-async-page-flips.patch)
    (patch ./winesync-hotfix.patch)
  ]
  ++ builtins.map (name: {
    inherit name;
    patch = "${inputs.linux-tkg}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches;
}
