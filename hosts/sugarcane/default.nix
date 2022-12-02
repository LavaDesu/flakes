{ config, inputs, modules, modulesPath, overlays, pkgs, ... }: {
  networking.hostName = "sugarcane";
  system.stateVersion = "21.11";
  time.timeZone = "Asia/Singapore";

  age.secrets = {
    passwd.file = ../../secrets/passwd.age;
    wg_sugarcane.file = ../../secrets/wg_sugarcane.age;
  };
  imports = (with modules.system; [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.home-manager-raccoon.nixosModule

    base
    home-manager
    input
    nix-stable
    security
    wireguard

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix
    ./packages.nix

    ../../users/hana
  ]) ++
  (with modules.services; [
    nginx
  ]);
}
