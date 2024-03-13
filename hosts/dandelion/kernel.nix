{ config, inputs, pkgs, ... }: {
  boot = {
    loader = {
      systemd-boot.enable = false;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        device = "/dev/sda";
      };
    };
    initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "xen_blkfront" ];
    initrd.kernelModules = [ "nvme" ];
    kernel.sysctl = {
      "kernel.core_pattern" = "|/bin/false";
      "kernel.sysrq" = 1;
    };
  };
}
