{ config, ... }:
let
  mkLabelMount = label: type: {
    device = "/dev/disk/by-label/${label}";
    fsType = type;
    options = [ "defaults" "relatime" ];
  };
  mkBtrfsMount = subvol: atime: mkLabelMount "CAKE" "btrfs" // {
    options = [ "autodefrag" "compress=zstd:3" "defaults" "discard=async" "space_cache=v2" "ssd" "subvol=${subvol}" (if atime then "relatime" else "noatime") ];
  };
in
{
  fileSystems = {
    "/" = {
      device = "rootfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=8G" "mode=755" ];
    };
    "/boot" = mkLabelMount "CUP" "vfat";

    "/mnt/butter" = mkBtrfsMount "/" true;
    "/nix" = mkBtrfsMount "/current/snow" false;
    "/home" = mkBtrfsMount "/current/home" true;
    "/home/.snapshots" = mkBtrfsMount "/snapshot/home" false;
    "/root" = mkBtrfsMount "/current/root" false;
    "/var" = mkBtrfsMount "/current/var" false;
    "/persist" = {
      depends = [ "/var" ];
      device = "/var/persist";
      fsType = "none";
      options = [ "bind" ];
      neededForBoot = true;
    };
  };
}
