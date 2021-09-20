{ config, pkgs, ... }: {
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
      };
    };
    initrd = {
      availableKernelModules = [ "uhci_hcd" "ehci_pci" "ahci" "virtio_pci" "sr_mod" "virtio_blk" ];
      kernelModules = [ "kvm-amd" ];
    };
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
