{ config, enableGUI, inputs, modules, ... }: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
  ];
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit enableGUI inputs modules;
      sysConfig = config;
    };
  };
}
