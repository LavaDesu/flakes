{ fetchFromGitHub, inputs, lib }:
let
  version = "6.11.5";
  kernelHash = "0bnbvadm4wvnwzcq319gsgl03ijvvljn7mj8qw87ihpb4p0cdljm";
  kernelPatchHash = "0fd9cq0w0hv822ds4yf5k2jmpmjybdkmlkla6c4k3xf746rv68hr";

  mm = lib.versions.majorMinor version;
  tkgPatches = [
    "0002-clear-patches"
    "0003-glitched-base"
    "0003-glitched-eevdf-additions"
    "0003-glitched-cfs"
    "0007-v${mm}-fsync1_via_futex_waitv"
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
