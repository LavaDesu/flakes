{ config, lib, pkgs, ... }: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    initrd.availableKernelModules = [ "xhci_pci" "nvme" ];
    initrd.kernelModules = [ "amdgpu" ];
    kernelParams = [
      "amdgpu.gpu_recovery=1"
      "intel_pstate=passive"
      "split_lock_detect=off"
    ];
    kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.me.linux-lava);
  };
}
