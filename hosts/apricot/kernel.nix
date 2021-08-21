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
    initrd.kernelModules = [ "i915" ];
    kernelParams = [
      "intel_pstate=passive"
    ];
    kernelPackages = pkgs.linuxPackages_latest;
  };
}
