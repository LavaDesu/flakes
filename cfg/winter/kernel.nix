{ config, pkgs, ...}: {
  powerManagement.cpuFreqGovernor = "performance";
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    blacklistedKernelModules = [
      "uvcvideo"
    ];
    kernel.sysctl = {
      "kernel.sysrq" = 1;
    };
    kernelParams = [
      "amdgpu.gpu_recovery=1"
      "amdgpu.si_support=1"
      "radeon.si_support=0"
      "intel_pstate=passive"
    ];
    kernelPackages = pkgs.linuxPackages_lqx;
  };
}
