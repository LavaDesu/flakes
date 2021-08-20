{ config, ... }:
let
  mkMount = uuid: type: {
    device = "/dev/disk/by-uuid/${uuid}";
    fsType = type;
    options = [ "defaults" "relatime" ];
  };
  mkBtrfsMount = subvolid: atime: mkMount "8f0ba28e-5dff-4a4e-8db0-aa72cc90cb5d" "btrfs" // {
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
    "/boot" = mkMount "E8E8-E570" "vfat";
    "/mnt/hdd" = mkMount "d5e3cfe5-c73a-4695-b81b-fc0215d4cefe" "ext4";

    "/mnt/butter" = mkBtrfsMount 5 true;
    "/nix" = mkBtrfsMount 258 false;
    "/home" = mkBtrfsMount 260 true;
    "/home/.snapshots" = mkBtrfsMount 319 false;
    "/root" = mkBtrfsMount 261 false;
    "/var" = mkBtrfsMount 259 false;

    # "/mnt/nfs" = {
    #   device = "192.168.100.11:/srv/nfs";
    #   fsType = "nfs";
    #   options = [ "defaults" ];
    # };
  };
}
