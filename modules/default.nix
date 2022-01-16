{ lib }:
let
  getName = path: lib.removeSuffix ".nix" ( # Strip extension
    lib.last (                              # Gets the last part (filename)
      lib.splitString "/" (                 # Splits the path into components
        builtins.toString path              # Converts the path into a string
      )
    )
  );
  mkAttrsFromPaths = paths: builtins.listToAttrs (
    builtins.map (path: {
      name = getName path;
      value = path;
    }) paths
  );
in {
  system = mkAttrsFromPaths [
    ./system/audio.nix
    ./system/base.nix
    ./system/greetd.nix
    ./system/gui.nix
    ./system/input.nix
    ./system/kernel.nix
    ./system/nix.nix
    ./system/packages.nix
    ./system/security.nix
    ./system/snapper.nix
    ./system/transmission.nix
    ./system/wireguard.nix
  ];
  user = mkAttrsFromPaths [
    ./user/bspwm.nix
    ./user/direnv.nix
    ./user/dunst.nix
    ./user/git.nix
    ./user/gpg.nix
    ./user/kitty.nix
    ./user/mpv.nix
    ./user/neovim.nix
    ./user/npm.nix
    ./user/packages-rin.nix
    ./user/picom.nix
    ./user/polybar.nix
    ./user/rofi.nix
    ./user/sessionVariables.nix
    ./user/sxhkd.nix
    ./user/theming.nix
    ./user/xdg.nix
    ./user/xorg.nix
    ./user/zsh.nix
  ];
}
