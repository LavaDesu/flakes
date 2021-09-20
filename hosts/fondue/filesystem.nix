{ config, ... }:
let
  mkMount = uuid: type: {
    device = "/dev/disk/by-uuid/${uuid}";
    fsType = type;
    options = [ "defaults" "relatime" ];
  };
  mkBtrfsMount = subvolid: atime: mkMount "8253d2ea-0813-4f71-9968-553965f0054b" "btrfs" // {
    options = [ "autodefrag" "compress=zstd:3" "defaults" "ssd" "ssd_spread" "subvolid=${builtins.toString subvolid}" (if atime then "relatime" else "noatime")];
  };
in
{
  fileSystems = {
    "/" = {
      device = "rootfs";
      fsType = "tmpfs";
      options = [ "defaults" "size=2G" "mode=755" ];
    };
    "/boot" = mkMount "0F35-9054" "vfat";

    "/mnt/butter" = mkBtrfsMount 5 true;
    "/nix" = mkBtrfsMount 258 false;
    "/home" = mkBtrfsMount 260 true;
    "/home/.snapshots" = mkBtrfsMount 262 false;
    "/root" = mkBtrfsMount 261 false;
    "/var" = mkBtrfsMount 259 false;
  };
}
