{ config, ... }:
let
  mkMount = uuid: type: {
    device = "/dev/disk/by-uuid/${uuid}";
    fsType = type;
  };
  mkBtrfsMount = subvolid: mkMount "8f0ba28e-5dff-4a4e-8db0-aa72cc90cb5d" "btrfs" // {
    options = [ "autodefrag" "compress=zstd:3" "nossd" "nossd_spread" "relatime" "subvolid=${builtins.toString subvolid}" ];
  };
in
{
  fileSystems = {
    "/" = {
      device = "rootfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=4G" "mode=755" ];
    };
    "/boot" = mkMount "E8E8-E570" "vfat";
    "/mnt/hdd" = mkMount "d5e3cfe5-c73a-4695-b81b-fc0215d4cefe" "ext4";

    "/mnt/butter" = mkBtrfsMount 5;
    "/nix" = mkBtrfsMount 258;
    "/home" = mkBtrfsMount 260;
    "/home/.snapshots" = mkBtrfsMount 319;
    "/root" = mkBtrfsMount 261;
    "/var" = mkBtrfsMount 259;
  };
}
