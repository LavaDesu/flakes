{ fetchFromGitHub, inputs, lib }:
let
  version = "6.4.12";
  kernelHash = "1wx7innfzlx508f7csfwp6k017wcljdy783pmi6a9v1c1j7mi84g";
  kernelPatchHash = "0va10x241v5dmks5p3242j5ihyfiydb3qri4mh6cjg0803mpzmnw";
  boreVersion = "3.1.2";

  mm = lib.versions.majorMinor version;
  tkgPatches = [
    "0001-mm-Support-soft-dirty-flag-reset-for-VA-range"
    "0002-clear-patches"
    "0002-mm-Support-soft-dirty-flag-read-with-reset"
    "0003-eevdf"
    "0003-glitched-base"
    "0003-glitched-cfs"
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
      url = "https://raw.githubusercontent.com/firelzrd/bore-scheduler/033cf689936a21af725207aa48f34076ac9a1f03/eevdf-bore-dev/0001-linux${mm}.y-eevdf-bore${boreVersion}.patch";
      sha256 = "019n33kfkjyx3zq8vjkl3jgilybhh6bznfybzhgjlyhs3qlrrrgw";
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
  ]
  ++ builtins.map (name: {
    inherit name;
    patch = "${inputs.linux-tkg}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches
  ++ [
    borePatch
  ];
}
