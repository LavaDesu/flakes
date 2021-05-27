{ config, pkgs, ...}: {
  powerManagement.cpuFreqGovernor = "performance";
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
    supportedFilesystems = ["bcachefs"];
    blacklistedKernelModules = [
      "uvcvideo"
    ];
    initrd = {
      includeDefaultModules = false;
      kernelModules = [ "i915" ];
    };
    kernel.sysctl = {
      "kernel.sysrq" = 1;
    };
    kernelParams = [
      "amdgpu.gpu_recovery=1"
      "amdgpu.si_support=1"
      "radeon.si_support=0"
      "intel_pstate=passive"
      "msr.allow_writes=on"
    ];
    kernelPackages = pkgs.lib.mkForce (pkgs.linuxPackagesFor pkgs.linux-lava);
  };
  zramSwap.enable = true;
}
