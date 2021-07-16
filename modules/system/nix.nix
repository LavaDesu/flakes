{ config, pkgs, ... }: {
  nix = rec {
    package = pkgs.nixUnstable;
    binaryCaches = [
      "https://cache.nixos.org?priority=10"
      "https://lava.cachix.org"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "lava.cachix.org-1:8lTWI/3IKWHByzzYHZySunMPYs2eAJw2duL+uLZkSy0="
    ];
    trustedBinaryCaches = binaryCaches;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.config.allowUnfree = true;
}