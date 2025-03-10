{ config, inputs, lib, ... }: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  options.catppuccin.colors = lib.mkOption {
    type = lib.types.attrs;
    default = (builtins.fromJSON (builtins.readFile "${inputs.catppuccin-palette}/palette.json"))."${config.catppuccin.flavor}".colors;
  };
  options.catppuccin.hexcolors = lib.mkOption {
    type = lib.types.attrs;
    default = builtins.mapAttrs (name: value: value.hex) config.catppuccin.colors;
  };

  config.catppuccin = {
    accent = "maroon";
    flavor = "mocha";
    kitty.enable = true;
    nvim.enable = true;
  };
}
