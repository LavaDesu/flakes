{ config, enableGUI, inputs, modules, ... }: {
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;
    extraSpecialArgs = {
      inherit enableGUI inputs modules;
    };
  };
}
