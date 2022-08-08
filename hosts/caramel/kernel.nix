{ config, inputs, lib, pkgs, ... }: {
  imports = [
    inputs.nixos-hardware.nixosModules.raspberry-pi-4
  ];
  hardware.raspberry-pi."4".fkms-3d.enable = true;

  boot = {
    initrd.kernelModules = [ "overlay" ];
    supportedFilesystems = lib.mkForce [ "btrfs" "vfat" ];
    kernel.sysctl = {
      "kernel.core_pattern" = "|/bin/false";
      "kernel.sysrq" = 1;
    };
  };
}
