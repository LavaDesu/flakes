{ fetchFromGitHub, inputs, lib }:
let
  version = "6.16.7";
  kernelHash = "10ydzfzc3g0nhns6md08gpfshhjcyd58lylqr15alijjdgzf4jqs";
  kernelPatchHash = "0l7hwyrvad3k41f5bg1y50ifyfwd5w47jkc2c5s376rafrcp30a4";

  mm = lib.versions.majorMinor version;
  hasPatch = (builtins.length (builtins.splitVersion version)) == 3;
  tkgPatches = [
    "0002-clear-patches"
    "0003-glitched-base"
    "0001-bore"
    "0003-glitched-cfs"
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

  kernelPatches = lib.optionals hasPatch [
    kernelPatchSrc
    (patch ./bluetooth.patch)
  ]
  ++ builtins.map (name: {
    inherit name;
    patch = "${inputs.linux-tkg}/linux-tkg-patches/${mm}/${name}.patch";
  }) tkgPatches
  ++ [ ];
}
