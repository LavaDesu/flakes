self: super: {
  picom = super.picom.overrideAttrs (old: {
    src = super.fetchFromGitHub {
      repo = "picom";
      owner = "yshui";
      rev = "31e58712ec11b198340ae217d33a73d8ac73b7fe";
      sha256 = "1hg5jfpknbcv9scaghpy2nbrg9cxwm8mkh6znpgbbzr05g7ch6al";
    };
  });
}
