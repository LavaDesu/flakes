{ config, lib, ... }:
let
  mkLabelMount = label: type: {
    device = "/dev/disk/by-label/${label}";
    fsType = type;
    options = [ "defaults" "relatime" ];
  };
  mkBtrfsMount = name: subvol: atime: mkLabelMount name "btrfs" // {
    options = [ "autodefrag" "compress=zstd:3" "defaults" "discard=async" "space_cache=v2" "ssd" "subvol=${subvol}" (if atime then "relatime" else "noatime") ];
  };
  submount = mkBtrfsMount "Anemone";
in
{
  fileSystems = {
    "/" = {
      device = "rootfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=8G" "mode=755" ];
    };
    "/boot" = mkLabelMount "SYSTEM" "vfat";

    "/mnt/butter" = submount "/" true;
    "/nix" = submount "/current/snow" false;
    "/home" = submount "/current/home" true;
    "/home/.snapshots" = submount "/snapshot/home" false;
    "/root" = submount "/current/root" false;
    "/var" = submount "/current/var" false;
    "/persist" = {
      depends = [ "/var" ];
      device = "/var/persist";
      fsType = "none";
      options = [ "bind" ];
      neededForBoot = true;
    };
  };
}
