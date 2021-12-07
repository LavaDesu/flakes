self: super: {
  rofi-unwrapped = super.rofi-unwrapped.overrideAttrs (_: rec {
    version = "1.7.2";

    src = super.fetchFromGitHub {
      owner = "davatorium";
      repo = "rofi";
      rev = version;
      fetchSubmodules = true;
      sha256 = "0yarkzhn7vxqxafmz196kvklzwdxygbhd0d29gxm7lrfba8brdxy";
    };
  });
}
