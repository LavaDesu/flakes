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
  services.xserver.xrandrHeads = [{
    output = "DP-1";
    primary = true;
    monitorConfig = ''
      Modeline "2560x1440_144.00"  808.75  2560 2792 3072 3584  1440 1443 1448 1568 -hsync +vsync
      Option "PreferredMode" "2560x1440_144.00"
    '';
  }];
}
