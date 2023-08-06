self: super: {
  steam = super.steam.override {
    extraPkgs = pkgs: with pkgs; [
      libkrb5
      keyutils
      gamescope
    ];

    extraLibraries = pkgs: with pkgs; [
      openssl_1_1
    ];
  };
}
