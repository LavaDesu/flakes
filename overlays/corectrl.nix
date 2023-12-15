self: super: {
  # copied from nixpkgs 94d828a5033b688af09b02983aad37ecf529bf3c to fix corectrl build failure on linux 6.6
  # awaiting merge into unstable

  corectrl = super.corectrl.overrideAttrs (old: rec {
    version = "1.3.8";
    src = self.fetchFromGitLab {
      owner = "corectrl";
      repo = "corectrl";
      rev = "v${version}";
      sha256 = "sha256-lc6yWzJiSzGKMzJIpgOtirJONsh49vXWDWrhLV/erwQ=";
    };

    patches = [ ./patches/corectrl.patch ];
  });
}
