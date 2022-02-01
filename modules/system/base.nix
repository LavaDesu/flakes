{ config, enableGUI, inputs, modules, overlays, ... }: {
  environment.etc = {
    "machine-id".source = "/var/persist/machine-id";
    "ssh/ssh_host_rsa_key".source = "/var/persist/ssh_host_rsa_key";
    "ssh/ssh_host_rsa_key.pub".source = "/var/persist/ssh_host_rsa_key.pub";
    "ssh/ssh_host_ed25519_key".source = "/var/persist/ssh_host_ed25519_key";
    "ssh/ssh_host_ed25519_key.pub".source = "/var/persist/ssh_host_ed25519_key.pub";
  };
  environment.pathsToLink = [ "/share/zsh" ];

  i18n.defaultLocale = "en_GB.UTF-8";
  users.mutableUsers = false;

  system = {
    configurationRevision = inputs.self.rev;
    nixos = rec {
      version = config.system.nixos.release + versionSuffix;
      versionSuffix = "-${config.system.name}.r${builtins.toString inputs.self.revCount}.${inputs.self.shortRev}";
    };
  };
  nix.registry.config.flake = inputs.self;
  nix.registry.nixpkgs.flake = inputs.nixpkgs;
  nix.registry.shells.flake = inputs.self;
}
