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
  };
}
