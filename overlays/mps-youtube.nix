self: super: {
  mps-youtube = super.mps-youtube.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      owner = "louisabraham";
      repo = "mps-youtube";
      rev = "234bc691f43f6df88d831409b2887fda45270636";
      sha256 = "14gsiacd05fsqb62zfapdll8dn1hbfi9vvh4wvk41qbxrla4p7d7";
    };
  });
}
