self: super: {
  winetricks = super.winetricks.overrideAttrs(old: rec {
    name = "winetricks-20210525-b9030c4";
    src = super.fetchFromGitHub {
      repo = "winetricks";
      owner = "Winetricks";
      rev = "b90e0c4e7cea9acc2c9e89bc4afe873086bbd8a1";
      sha256 = "11adhgd8zavz4c9yzj0m5570fq7wv6am2wq4j9xkz2655fw2412l";
    };
    patches = [ ./winetricks.patch ];
  });
}
