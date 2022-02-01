{ config, inputs, modules, modulesPath, overlays, pkgs, ... }: {
  networking.hostName = "fondue";
  system.stateVersion = "21.05";
  time.timeZone = "Australia/Melbourne";

  age.secrets = {
    passwd.file = ../../secrets/passwd.age;
    wg_fondue.file = ../../secrets/wg_fondue.age;
  };
  imports = with modules.system; [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.home-manager.nixosModule
    home-manager

    base
    input
    kernel
    nix
    packages
    security
    snapper
    wireguard

    ./filesystem.nix
    ./firewall.nix
    ./kernel.nix
    ./networking.nix

    ../../users/rin
  ];
}

