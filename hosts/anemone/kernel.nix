{ config, lib, pkgs, ... }: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    initrd.availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelModules = [ "kvm-amd" ];
    kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.me.linux-lava);
  };

  hardware.cpu.amd.updateMicrocode = true;
}
