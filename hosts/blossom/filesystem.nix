{ config, ... }:
let
  mkMount = uuid: type: {
    device = "/dev/disk/by-uuid/${uuid}";
    fsType = type;
    options = [ "defaults" "relatime" ];
  };
  mkBtrfsMount = subvolid: atime: mkMount "cf0f4302-f006-46a5-afc7-ada04d17f6f2" "btrfs" // {
    options = [ "autodefrag" "compress=zstd:3" "defaults" "discard=async" "space_cache=v2" "ssd" "subvolid=${builtins.toString subvolid}" (if atime then "relatime" else "noatime") ];
  };
in
{
  fileSystems = {
    "/" = {
      device = "rootfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=4G" "mode=755" ];
    };
    "/boot" = mkMount "186A-A42E" "vfat";
    "/mnt/hdd" = mkMount "d5e3cfe5-c73a-4695-b81b-fc0215d4cefe" "ext4";
    "/mnt/prev" = mkMount "8f0ba28e-5dff-4a4e-8db0-aa72cc90cb5d" "btrfs" // {
      options = [ "autodefrag" "compress=zstd:3" "defaults" "nossd" "noatime" "ro" ];
    };

    "/mnt/butter" = mkBtrfsMount 5 true;
    "/nix" = mkBtrfsMount 257 false;
    "/home" = mkBtrfsMount 259 true;
    "/home/.snapshots" = mkBtrfsMount 262 false;
    "/root" = mkBtrfsMount 260 false;
    "/var" = mkBtrfsMount 258 false;

    # "/mnt/nfs" = {
    #   device = "192.168.100.11:/srv/nfs";
    #   fsType = "nfs";
    #   options = [ "defaults" ];
    # };
  };
}
