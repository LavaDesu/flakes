{ fetchFromGitHub, inputs, lib }:
let
  version = "6.3.8";
  kernelHash = "07ivnxynbmvk3sh2z4i8sp6my2397m746h64f2ip1lkbxpsr2d5s";
  kernelPatchHash = "1d4154704940g7h58mv5djkcvhy334zslh161giwhmm57lysjywj";

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
      url = "https://raw.githubusercontent.com/CachyOS/kernel-patches/a108a60471fe304e5321394238a4f6107a1d466e/${mm}/sched/0001-bore.patch";
      sha256 = "1qvy3sq6vc7f1mggwkxrmbzmwjabp3vmcywm81gmbcpd87l786n9";
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
    #(patch ./si-manual-clocking.patch)
    #(patch ./atomic-async-page-flips.patch)
    #(patch ./winesync-hotfix.patch)
  ]
  ++ builtins.map (name: {
    inherit name;
    patch = "${inputs.linux-tkg}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches;
}
