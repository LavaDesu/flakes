{ config, lib, pkgs, ... }: {
  nix = rec {
    # XXX: remove after upstream fixes https://github.com/NixOS/nix/issues/5728
    package = pkgs.nixUnstable.overrideAttrs(_: rec {
      version = "2.5${suffix}";
      suffix = "pre20211007_${lib.substring 0 7 src.rev}";
      src = pkgs.fetchFromGitHub {
        owner = "NixOS";
        repo = "nix";
        rev = "844dd901a7debe8b03ec93a7f717b6c4038dc572";
        sha256 = "sha256-fe1B4lXkS6/UfpO0rJHwLC06zhOPrdSh4s9PmQ1JgPo=";
      };
    });
    binaryCaches = [
      "https://cache.nixos.org?priority=10"
      "https://lava.cachix.org"
      "https://nix-gaming.cachix.org"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "lava.cachix.org-1:8lTWI/3IKWHByzzYHZySunMPYs2eAJw2duL+uLZkSy0="
      "nix-gaming.cachix.org-1:nbjlureqMbRAxR1gJ/f3hxemL9svXaZF/Ees8vCUUs4="
    ];
    trustedBinaryCaches = binaryCaches;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.config.allowUnfree = true;
}
