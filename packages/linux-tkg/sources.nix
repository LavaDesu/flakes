{ fetchFromGitHub, lib, version }:
let
  vMap = {
    "5.4" = {
      version = "5.4.128";
      hash = "1arrpskxkkl6vb06d4y4xvfy1355mjk5ac5sp66657kbh6xswm1v";
    };
    "5.10" = {
      version = "5.10.46";
      hash = "058lvk0hc6qk3l485kda7cxkdrjk1kd0f75cp7pmnckbkjij54an";
    };
    "5.12" = {
      version = "5.12.13";
      hash = "0mfjkncsa7vq13689dzzwms6wzsaj347qm1vf7k82nb3wp6myj5g";
    };
  };

  tkg = fetchFromGitHub {
    owner = "Frogging-Family";
    repo = "linux-tkg";
    rev = "c93cfdd20da1cf3b0860895c278b5a4676ccb057";
    sha256 = "0xpkdjq2ickhb8pqzqv5avjmrg3qyzryy8qv1wr9dxpkx197swdx";
  };

  ver =
    if builtins.hasAttr version vMap
    then vMap.${version}
    else throw "Unsupported version";
in rec {
  inherit tkg;

  fullVersion = ver.version;
  kernelSrc = builtins.fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v${lib.versions.major version}.x/linux-${fullVersion}.tar.xz";
    sha256 = ver.hash;
  };
}
