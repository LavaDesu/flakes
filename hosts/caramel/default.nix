{ config, inputs, modules, overlays, pkgs, ... }: {
  networking.hostName = "caramel";
  system.stateVersion = "21.11";
  time.timeZone = "Asia/Phnom_Penh";

  age.secrets = {
    passwd.file = ../../secrets/passwd.age;
    wpa_conf.file = ../../secrets/wpa_conf.age;
  };
  imports = with modules.system; [
    inputs.home-manager-porcupine.nixosModule

    base
    home-manager
    input
    nix-porcupine
    security
    wireguard

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix
    ./packages.nix

    ../../users/hana
  ];
}
