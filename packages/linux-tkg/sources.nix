{ fetchFromGitHub, lib, version }:
let
  vMap = {
    "5.4" = {
      version = "5.4.128";
      baseHash = "14glqppn90z79b36k4c76mv90q933i2bg54rgwlcl2v7n608jcxz";
      patchHash = "04ylr4f4amzviqljhc6i79dqhjmjx45shf0rply1v5zqlfndb459";
    };
    "5.10" = {
      version = "5.10.46";
      baseHash = "0hyav21vzz5v1kgb455pcz9ncg5qqzxmp60na290scwq7vj9kpyw";
      patchHash = "0jl31aayxyns3pkvm9mycvwakg2i45win9nfbirhcz7z5gfsa7fg";
    };
    "5.12" = {
      version = "5.12.13";
      baseHash = "0rn3z942vjc7bixjw066rm6kcr0x0wzgxqfq1f6xd113pzrgc3bx";
      patchHash = "17d38hns5qfbw1pajpa5y38v86r49nqnw7a3pwsay5fapj69z8w4";
    };
  };

  tkg = fetchFromGitHub {
    owner = "Frogging-Family";
    repo = "linux-tkg";
    rev = "2da317c20ed6f70085b195639b9aad2cacf31ab5";
    sha256 = "06a5fpafids8nc550pcsyvar2igphi6bpghqzl6cp48hg6p2g07w";
  };

  ver =
    if builtins.hasAttr version vMap
    then vMap.${version}
    else throw "Unsupported version";
in rec {
  inherit tkg;

  fullVersion = ver.version;
  kernelSrc = builtins.fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v${lib.versions.major version}.x/linux-${version}.tar.xz";
    sha256 = ver.baseHash;
  };
  patchSrc = builtins.fetchurl {
    url = "https://cdn.kernel.org/pub/linux/kernel/v${lib.versions.major version}.x/patch-${fullVersion}.xz";
    sha256 = ver.patchHash;
  };
}
