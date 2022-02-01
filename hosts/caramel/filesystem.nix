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

    "/nix" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
      options = [ "defaults" "noatime" ];
    };

    "/var/persist" = bind "/nix/persist";
    "/var/log/journal" = bind "/nix/persist/journal";
    "/boot" = bind "/nix/persist/boot";
  };
}
