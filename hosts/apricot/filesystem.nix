{ config, ... }:
let
  mkMount = uuid: type: {
    device = "/dev/disk/by-uuid/${uuid}";
    fsType = type;
    options = [ "defaults" "relatime" ];
  };
  mkBtrfsMount = subvolid: atime: mkMount "c79ebe18-2d2b-4f0f-9940-afd9378afa09" "btrfs" // {
    options = [ "autodefrag" "compress=zstd:3" "defaults" "nossd" "nossd_spread" "subvolid=${builtins.toString subvolid}" (if atime then "relatime" else "noatime")];
  };
in
{
  fileSystems = {
    "/" = {
      device = "rootfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=4G" "mode=755" ];
    };
    "/boot" = mkMount "2818-A529" "vfat";
    "/mnt/hdd" = mkMount "436ad832-8dcc-4813-b663-4d0b7b773ff2" "ext4";

    "/mnt/butter" = mkBtrfsMount 5 true;
    "/nix" = mkBtrfsMount 258 false;
    "/home" = mkBtrfsMount 260 true;
    "/home/.snapshots" = mkBtrfsMount 263 false;
    "/root" = mkBtrfsMount 261 false;
    "/var" = mkBtrfsMount 259 false;
  };
}
