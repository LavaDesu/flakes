{ config, inputs, lib, pkgs, ... }: {
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

  config = {
    catppuccin = {
      accent = "maroon";
      flavor = lib.mkDefault "mocha";
      kitty.enable = true;
      gtk.enable = true;
      hyprlock.enable = true;
      kvantum.enable = true;
      nvim.enable = true;
    };
    qt = {
      enable = true;
      style.name = "kvantum";
      platformTheme.name = "kvantum";
    };

    specialisation = {
      light.configuration.catppuccin.flavor = "latte";
      dark.configuration.catppuccin.flavor = "mocha";
    };

    home.packages = [(pkgs.writeShellScriptBin "theme" ''
      if [ "$1" != "dark" ] && [ "$1" != "light" ]; then
        echo "invalid theme, valid values: [dark, light]"
        exit 1
      fi
      current="$HOME/.local/state/nix/profiles/home-manager"
      cached="$HOME/.local/state/last-parent-specialisation"
      if [ -d "$current/specialisation" ]; then
        if [ -d "$cached" ]; then
          rm -f "$cached"
        fi
        ln -sf "$(readlink -f $current)" "$cached"
      fi

      if [ ! -d "$cached/specialisation" ]; then
        echo "no specialisations found"
        exit 1
      fi

      "$cached/specialisation/$1/activate"
    '')];
  };
}
