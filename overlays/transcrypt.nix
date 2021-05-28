self: super: {
  transcrypt = super.transcrypt.overrideAttrs(o: rec {
    version = "2.1.0";

    patches = [ ./misc/transcrypt.patch ];
    src = super.fetchFromGitHub {
      owner = "elasticdog";
      repo = "transcrypt";
      rev = "v${version}";
      sha256 = "0bpz1hazbhfb6pqi68x55kq6a31bgh6vwij836slmi4jqiwvnh5a";
    };
  });
}
