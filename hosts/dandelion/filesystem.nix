{ config, lib, ... }:
let
  bind = src: {
    depends = [ "/nix" ];
    device = src;
    fsType = "none";
    neededForBoot = true;
    options = [ "bind" ];
  };

  mkLabelMount = label: type: lazy: {
    device = "/dev/disk/by-label/${label}";
    fsType = type;
    options = [ "defaults" "relatime" ] ++ lib.optionals lazy [ "nofail" ];
  };
  mkBtrfsMount = name: subvol: atime: mkLabelMount name "btrfs" false // {
    options = [ "autodefrag" "compress=zstd:3" "defaults" "discard=async" "space_cache=v2" "ssd" "subvol=${subvol}" (if atime then "relatime" else "noatime") ];
  };
  submount = mkBtrfsMount "DANDELION";
in {
  fileSystems = {
    "/" = {
      device = "rootfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=12G" "mode=755" ];
    };

    "/boot" = mkLabelMount "UEFI" "vfat" true;
    "/nix" = submount "/@/nix" false;
    "/persist" = (submount "/@/persist" true) // { neededForBoot = true; };
    "/persist/.snapshots" = submount "/snap/persist" false;
    "/var/log/journal" = bind "/persist/journal";
  };
}
