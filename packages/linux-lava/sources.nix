{ fetchFromGitHub, inputs, lib }:
let
  version = "5.15.6";
  kernelHash = "1s0yk78kilcr3vd14k67cmllnrx0x0i00jdkl5kkn3lij5lwzcjp";
  kernelPatchHash = "07k2vqf0mynladx23p980yi71fhqimr997s4azvqxwg244qpbx93";
  caculeRev = "2ac16b14bc0281c3b6c14828688981633b82ffd8";
  caculeHash = "0li0zaizxvpigngv1954hkw8dirwyvqy93gb3af33cm47ir9049p";

  tkgPatches = [
    "0001-mm-Support-soft-dirty-flag-reset-for-VA-range"
    "0002-clear-patches"
    "0002-mm-Support-soft-dirty-flag-read-with-reset"
    #"0003-cacule-${mm}"
    "0003-glitched-base"
    "0003-glitched-cfs"
    "0007-v${mm}-futex_waitv"
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
  caculeSrc = {
    name = "cacule";
    patch = builtins.fetchurl {
      url = "https://raw.githubusercontent.com/CachyOS/cacule-cpu-scheduler/${caculeRev}/patches/CacULE/v${mm}/cacule-${mm}-full.patch";
      sha256 = caculeHash;
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
    kernelPatchSrc
    caculeSrc
    (patch ./si-manual-clocking.patch)
  ]
  ++ builtins.map (name: {
    inherit name;
    patch = "${inputs.linux-tkg}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches;
}
