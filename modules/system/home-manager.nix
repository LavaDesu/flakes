{ config, enableGUI, inputs, modules, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit enableGUI inputs modules;
      sysConfig = config;
    };
    # uncomment to prevent nmd IFD
    # sharedModules = [ { manual.manpages.enable = false; } ];

    # HACK: due to git cve, nixos-rebuild --flake breaks; revert after nix is fixed
    users.root.programs.git = {
      enable = true;
      extraConfig.safe.directory = "*";
    };
  };
}
