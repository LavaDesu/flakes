{ config, modules, overlays, pkgs, ... }: {
  networking.hostName = "apricot";
  system.stateVersion = "21.05";
  time.timeZone = "Asia/Phnom_Penh";

  age.secrets = {
    passwd.file = ../../secrets/passwd.age;
    wpa_conf.file = ../../secrets/wpa_conf.age;
  };
  imports = with modules.system; [
    base
    input
    kernel
    nix
    packages
    security
    snapper

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix

    ../../users/rin.nix
  ];
}

