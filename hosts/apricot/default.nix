{ config, modules, overlays, pkgs, ... }: {
  networking.hostName = "apricot";
  system.stateVersion = "21.05";
  time.timeZone = "Asia/Phnom_Penh";

  age.secrets = {
    passwd.file = ../../secrets/passwd.age;
    wg_apricot.file = ../../secrets/wg_apricot.age;
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
    wireguard

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix

    ../../users/rin.nix
  ];
}

