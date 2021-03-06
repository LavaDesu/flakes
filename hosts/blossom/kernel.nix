{ config, lib, pkgs, ... }: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      grub = {
        enable = true;
        efiSupport = true;
        device = "nodev";
        useOSProber = lib.mkForce false;
      };
    };
    initrd.kernelModules = [ "i915" ];
    kernelParams = [
      "amdgpu.gpu_recovery=1"
      "amdgpu.si_support=1"
      "radeon.si_support=0"
      "intel_pstate=passive"
      "msr.allow_writes=on"
    ];
    kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.me.linux-lava);

    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback.out ];
    kernelModules = [ "v4l2loopback" ];
  };
}
