{ config, inputs, modules, modulesPath, overlays, pkgs, ... }: {
  networking.hostName = "caramel";
  system.stateVersion = "22.11";
  time.timeZone = "Asia/Phnom_Penh";

  age.secrets = {
    acme_dns.file = ../../secrets/acme_dns.age;
    passwd.file = ../../secrets/passwd.age;
    warden_admin.file = ../../secrets/warden_admin.age;
    wpa_conf.file = ../../secrets/wpa_conf.age;
    wg_caramel.file = ../../secrets/wg_caramel.age;
  };
  imports =
    (with modules.system; [
      "${builtins.toString modulesPath}/installer/sd-card/sd-image-aarch64.nix"
      inputs.home-manager-raccoon.nixosModule

      base
      home-manager
      input
      nix-stable
      security
      transmission
      wireguard

      ./filesystem.nix
      ./kernel.nix
      ./image.nix
      ./networking.nix
      ./packages.nix

      ../../users/hana
    ]) ++
    (with modules.services; [
#       nginx
#       postgres
#       synapse
      jellyfin
      sonarr
      tmptsync
      unbound
    ]);
}
