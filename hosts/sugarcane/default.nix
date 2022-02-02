{ config, inputs, modules, modulesPath, overlays, pkgs, ... }: {
  networking.hostName = "sugarcane";
  system.stateVersion = "21.11";
  time.timeZone = "Asia/Singapore";

  age.secrets = {
    passwd.file = ../../secrets/passwd.age;
  };
  imports = with modules.system; [
    (modulesPath + "/profiles/qemu-guest.nix")
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
