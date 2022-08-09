{ config, lib, ... }:
let
  bind = src: {
    depends = [ "/persist" ];
    device = src;
    fsType = "none";
    neededForBoot = true;
    options = [ "bind" ];
  };
in {
  fileSystems = {
    "/" = lib.mkForce {
      device = "rootfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=1G" "mode=755" ];
    };

    # "/nix" = {
    #   device = "overlayfs";
    #   fsType = "overlay";
    #   options = [
    #     "lowerdir=/mnt/image/nix"
    #     "upperdir=/persist/nix-overlay"
    #     "workdir=/persist/.overlaytmp"
    #   ];
    #   noCheck = true;
    #   depends = [ "/mnt/image" "/persist" ];
    # };

    "/nix" = (bind "/mnt/image/nix") // { depends = [ "/mnt/image" ]; };

    "/mnt/image" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "defaults" "noatime" ];
      neededForBoot = true;
    };

    "/persist" = {
      device = "/dev/disk/by-label/PI_HDD";
      fsType = "ext4";
      options = [ "defaults" "relatime" ];
      neededForBoot = true;
    };

    "/var/lib/acme" = bind "/persist/acme";
    "/var/log/journal" = bind "/persist/journal";
    "/boot" = (bind "/mnt/image/boot") // { depends = [ "/mnt/image" ]; };
  };
}
