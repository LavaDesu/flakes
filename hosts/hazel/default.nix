{ modules, pkgs, ... }: {
  networking.hostName = "hazel";
  system.stateVersion = "24.11";
  time.timeZone = "Australia/Melbourne";

  imports = with modules.system; [
    home-manager-stable

    base
    kernel
    nginx
    nix-stable
    packages
    security

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix

    ../../users/hana
  ];

  me.environment = "headless";

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "cloud.lava.moe";
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = "/persist/nextcloud-admin-pass";
    };
  };
}
