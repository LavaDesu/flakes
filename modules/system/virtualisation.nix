{ pkgs, ... }: {
  virtualisation = {
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm.override { smbdSupport = true; };
    };
  };
}
