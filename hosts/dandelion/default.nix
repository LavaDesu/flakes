{ modules, modulesPath, ... }: {
  networking.hostName = "dandelion";
  system.stateVersion = "23.11";
  time.timeZone = "Australia/Melbourne";

  age.secrets = {
    acme_dns.file = ../../secrets/acme_dns.age;
  };

  imports = with modules.system; [
    (modulesPath + "/profiles/qemu-guest.nix")
    home-manager-stable

    base
    kernel
    nix-stable
    packages
    security

    modules.services.nginx
    modules.services.postgres

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix
    ./transmission-container.nix

    ../../users/hana
  ];

  me.environment = "headless";
}
