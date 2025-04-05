{ ... }:
let
  mkLabelMount = label: type: options: {
    device = "/dev/disk/by-label/${label}";
    fsType = type;
    options = [ "defaults" ] ++ options;
  };
  mkBtrfsMount = name: ext: subvol: atime: mkLabelMount name "btrfs"
  ([
    "autodefrag"
    "compress=zstd:4"
    "compress-force=zstd:4"
    "defaults"
    "nossd"
    "space_cache=v2"
    "subvol=${subvol}"
    (if atime then "relatime" else "noatime")
  ] ++ ext);

  mkHazelMount = mkBtrfsMount "HAZEL" [ "noauto" ];
in
{
  boot.supportedFilesystems = [ "btrfs" ];
  fileSystems = {
    "/" = {
      device = "rootfs";
      fsType = "tmpfs";
      options = [ "defaults" "mode=755" ];
    };
    "/boot" = mkLabelMount "ROOT" "vfat" [];

    "/flower" = mkHazelMount "/current/flower" true;
    "/persist" = mkHazelMount "/current/persist" true;
    "/var" = mkHazelMount "/current/var" true;
    "/nix" = mkHazelMount "/current/nix" false;

    "/mnt" = mkHazelMount "/" true;
  };

  services.snapper.cleanupInterval = "1h";
  services.snapper.configs.flower = {
      FSTYPE = "btrfs";
      SUBVOLUME = "/mnt/current/flower";
      TIMELINE_CLEANUP = true;
      TIMELINE_CREATE = true;
      TIMELINE_MIN_AGE = "1800";
      TIMELINE_LIMIT_HOURLY = "5";
      TIMELINE_LIMIT_DAILY = "7";
      TIMELINE_LIMIT_WEEKLY = "0";
      TIMELINE_LIMIT_MONTHLY = "0";
      TIMELINE_LIMIT_YEARLY = "0";
    };
}
