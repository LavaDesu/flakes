{ config, modules, overlays, pkgs, ... }: {
  networking.hostName = "blossom";
  system.stateVersion = "21.11";
  time.timeZone = "Asia/Phnom_Penh";

  age.secrets = {
    passwd.file = ../../secrets/passwd.age;
    wg_blossom.file = ../../secrets/wg_blossom.age;
    wpa_conf.file = ../../secrets/wpa_conf.age;
  };
  imports = with modules.system; [
    audio
    base
    greetd
    gui
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

    ../../users/rin
  ];
}

