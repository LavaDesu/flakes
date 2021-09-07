{ fetchFromGitHub, lib }:
let
  version = "5.14.1";
  kernelHash = "1cki6af9r30k8820j73qdyycp23mwpf2a2rjwl82p9i61mg8n1ky";
  kernelPatchHash = "1ms4ybm1v83m8hwg1ymw2g8blf0mq1n3h0rzg8kmd3sh7vjbph4n";
  tkgRev = "0eaf5ba619ac3b82bbdb7bd1c1eb5ed3a2164272";
  tkgHash = "10q0anzfjh7qwa8xqjl3rzvi7vblykvv4bavi8qfs6lbk6isf00a";
  caculeRev = "d03c1167152d4af037fc008bc9fa651b900d75d5";
  caculeHash = "0xcfamxs4znmq3wfracr5jf59dlpig0b5s0aabi9zqzb61ds7i5z";

  tkgPatches = [
    "0001-mm-Support-soft-dirty-flag-reset-for-VA-range"
    "0002-clear-patches"
    "0002-mm-Support-soft-dirty-flag-read-with-reset"
    #"0003-cacule-${mm}"
    "0003-glitched-base"
    "0003-glitched-cfs"
    "0007-v${mm}-fsync"
    "0007-v${mm}-futex2_interface"
    "0007-v${mm}-winesync"
    "0012-misc-additions"
  ];


  patch = path: {
    name = "patch-${path}";
    patch = path;
  };
  tkgSrc = fetchFromGitHub {
    owner = "Frogging-Family";
    repo = "linux-tkg";
    rev = tkgRev;
    sha256 = tkgHash;
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
        url = "https://raw.githubusercontent.com/hamadmarri/cacule-cpu-scheduler/${caculeRev}/patches/CacULE/v${mm}/cacule-${mm}.patch";
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
    patch = "${tkgSrc}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches;
}
