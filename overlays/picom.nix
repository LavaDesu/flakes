self: super: {
  picom = super.picom.overrideAttrs(old: {
    src = super.fetchFromGitHub {
      repo = "picom";
      owner = "ibhagwan";
      rev = "60eb00ce1b52aee46d343481d0530d5013ab850b";
      sha256 = "1m17znhl42sa6ry31yiy05j5ql6razajzd6s3k2wz4c63rc2fd1w";
    };
  });
}
