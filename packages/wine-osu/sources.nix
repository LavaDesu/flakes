{ fetchFromGitHub, lib }:
let
  version = "6.14";
in {
  inherit version;
  src = builtins.fetchurl {
    url = "https://dl.winehq.org/wine/source/6.x/wine-${version}.tar.xz";
    sha256 = "sha256-ZLRxk5lDvAjjUQJ9tvvCRlwTllCjv/65Flf/DujCUgI=";
  };

  staging = fetchFromGitHub {
    sha256 = "sha256-yzpRWNx/e3BDCh1dyf8VdjLgvu6yZ/CXre/cb1roaVs=";
    owner = "wine-staging";
    repo = "wine-staging";
    rev = "v${version}";
  };
}
