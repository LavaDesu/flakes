# TODO: remove after upstream fixes https://github.com/NixOS/nix/issues/5728
self: super: {
  nixUnstable = super.nixUnstable.override rec {
    version = "2.5${suffix}";
    suffix = "pre20211007_${super.lib.substring 0 7 src.rev}";
    src = super.fetchFromGitHub {
      owner = "NixOS";
      repo = "nix";
      rev = "844dd901a7debe8b03ec93a7f717b6c4038dc572";
      sha256 = "sha256-fe1B4lXkS6/UfpO0rJHwLC06zhOPrdSh4s9PmQ1JgPo=";
    };
  };
}
