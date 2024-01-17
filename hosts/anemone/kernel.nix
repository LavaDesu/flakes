{ config, lib, pkgs, ... }: {
  boot = {
    consoleLogLevel = 0;
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
    };
    initrd = {
      availableKernelModules = [ "xhci_pci" "nvme" "usb_storage" "sd_mod" "rtsx_pci_sdmmc" ];
      verbose = false;
    };
    kernelModules = [ "kvm-amd" ];
    kernelPackages = lib.mkForce (pkgs.linuxPackagesFor pkgs.me.linux-lava);
    kernelParams = [
      "quiet"
      "console=tty2"
      "systemd.show_status=0"
      "rd.systemd.show_status=0"
      "rd.udev.log_level=3"
      "udev.log_level=3"
      "udev.log_priority=3"
    ];
  };

  hardware.cpu.amd.updateMicrocode = true;

  hardware.firmware = let
    fw = "${pkgs.linux-firmware}/lib/firmware/cirrus/";
   in [(
    pkgs.runCommandNoCC "cs35l41-10431683" { } ''
      mkdir -p $out/lib/firmware/cirrus
      cd $out/lib/firmware/cirrus
      cp ${fw}/cs35l41-dsp1-spk-cali-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-cali-10431683-spkid0-l0.bin
      cp ${fw}/cs35l41-dsp1-spk-cali-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-cali-10431683-spkid0-r0.bin
      cp ${fw}/cs35l41-dsp1-spk-cali-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-cali-10431683-spkid1-l0.bin
      cp ${fw}/cs35l41-dsp1-spk-cali-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-cali-10431683-spkid1-r0.bin

      cp ${fw}/cs35l41-dsp1-spk-prot-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-prot-10431683-spkid0-l0.bin
      cp ${fw}/cs35l41-dsp1-spk-prot-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-prot-10431683-spkid0-r0.bin
      cp ${fw}/cs35l41-dsp1-spk-prot-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-prot-10431683-spkid1-l0.bin
      cp ${fw}/cs35l41-dsp1-spk-prot-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-prot-10431683-spkid1-r0.bin

      cp ${fw}/cs35l41-dsp1-spk-cali-10431e12.wmfw cs35l41-dsp1-spk-cali-10431683.wmfw
      cp ${fw}/cs35l41-dsp1-spk-prot-10431e12.wmfw cs35l41-dsp1-spk-prot-10431683.wmfw
    ''
  )];
}
