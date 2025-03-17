{ config, pkgs, ... }: {
  boot = {
    blacklistedKernelModules = [ "uvcvideo" ];
    initrd = {
      includeDefaultModules = false;
      availableKernelModules = [ "ehci_pci" "ahci" "usbhid" "usb_storage" "sd_mod" "sdhci_pci" ];
    };
    kernel.sysctl = {
      "kernel.core_pattern" = "|/bin/false";
      "kernel.sysrq" = 1;
    };
  };
  hardware.enableRedistributableFirmware = true;
  zramSwap = {
    enable = true;
    priority = 100;
  };
}
