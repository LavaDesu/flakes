{ inputs, ... }: {
  imports = [
    inputs.catppuccin.homeManagerModules.catppuccin
  ];

  catppuccin = {
    accent = "maroon";
    flavor = "mocha";
    kitty.enable = true;
    nvim.enable = true;
  };
}
