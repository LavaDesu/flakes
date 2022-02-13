{ config, ... }:
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
    "/" = {
      device = "rootfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" ];
    };

    "/nix" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "defaults" "noatime" ];
    };

    "/persist" = {
      device = "/dev/disk/by-label/PI_HDD";
      fsType = "ext4";
      options = [ "defaults" "relatime" ];
      neededForBoot = true;
    };

    "/var/persist" = bind "/persist";
    "/var/log/journal" = bind "/persist/journal";
    "/boot" = (bind "/nix/persist/boot") // { depends = [ "/nix" ]; };
  };
}
