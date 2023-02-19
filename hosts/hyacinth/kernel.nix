{ config, lib, pkgs, ... }: {
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    initrd.availableKernelModules = [ "xhci_pci" "nvme" ];
    initrd.kernelModules = [ "kms" ];
    kernelParams = [
      "amdgpu.gpu_recovery=1"
      "intel_pstate=passive"
      "split_lock_detect=off"
    ];
    kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.me.linux-lava);

    extraModulePackages = [ config.boot.kernelPackages.v4l2loopback.out ];
    kernelModules = [ "v4l2loopback" ];
  };
  services.xserver.xrandrHeads = [{
    output = "DisplayPort-0";
    primary = true;
    monitorConfig = ''
      Modeline "1920x1080_165.00"  525.00  1920 2088 2296 2672  1080 1083 1088 1192 -hsync +vsync
      Option "PreferredMode" "1920x1080_165.00"
    '';
  }];
}
