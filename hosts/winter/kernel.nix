{ config, pkgs, ... }: {
  powerManagement.cpuFreqGovernor = "ondemand";
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
    blacklistedKernelModules = ["uvcvideo"];
    initrd = {
      includeDefaultModules = false;
      kernelModules = [ "i915" ];
    };
    kernel.sysctl = {
      "kernel.core_pattern" = "|/bin/false";
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
