{ config, ... }:
let
  bind = src: {
    depends = [ "/nix" ];
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

    "/mnt" = {
      device = "/dev/disk/by-uuid/19d572a8-1cf6-4b9c-94c6-3ce6be54f719";
      fsType = "ext4";
      options = [ "defaults" "noatime" ];
      neededForBoot = true;
    };

    "/nix" = {
      depends = [ "/mnt" ];
      device = "/mnt/nix";
      fsType = "none";
      neededForBoot = true;
      options = [ "bind" ];
    };

    "/var/persist" = bind "/nix/persist";
    "/var/log/journal" = bind "/nix/persist/journal";
    "/boot" = bind "/nix/persist/boot";
  };
}
