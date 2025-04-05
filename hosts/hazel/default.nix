{ modules, ... }: {
  networking.hostName = "hazel";
  system.stateVersion = "24.11";
  time.timeZone = "Australia/Melbourne";

  imports = with modules.system; [
    home-manager-stable

    base
    kernel
    nix-stable
    packages
    security

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix

    ../../users/hana
  ];
}
