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
  services = mkAttrsFromPaths [
    ./services/jellyfin.nix
    ./services/nginx.nix
    ./services/postgres.nix
    ./services/sonarr.nix
    ./services/synapse.nix
    ./services/tmptsync.nix
    ./services/unbound.nix
    ./services/vaultwarden.nix
  ];
  system = mkAttrsFromPaths [
    ./system/aagl.nix
    ./system/audio.nix
    ./system/base.nix
    ./system/bluetooth.nix
    ./system/ccache.nix
    ./system/corectrl.nix
    ./system/flatpak.nix
    ./system/greetd_wayland.nix
    ./system/greetd_xorg.nix
    ./system/gui.nix
    ./system/home-manager.nix
    ./system/input.nix
    ./system/kernel.nix
    ./system/nix.nix
    ./system/nix-stable.nix
    ./system/packages.nix
    ./system/printing.nix
    ./system/security.nix
    ./system/snapper.nix
    ./system/transmission.nix
    ./system/virtualisation.nix
    ./system/wireguard.nix
  ];
  user = mkAttrsFromPaths [
    ./user/bspwm.nix
    ./user/catppuccin.nix
    ./user/direnv.nix
    ./user/dunst.nix
    ./user/eww.nix
    ./user/eww-wayland.nix
    ./user/git.nix
    ./user/gpg.nix
    ./user/hypridle.nix
    ./user/hyprlock.nix
    ./user/kitty.nix
    ./user/mpv.nix
    ./user/neovim.nix
    ./user/neovim-minimal.nix
    ./user/npm.nix
    ./user/obs.nix
    ./user/packages-rin.nix
    ./user/pass.nix
    ./user/picom.nix
    ./user/polybar.nix
    ./user/rofi.nix
    ./user/rofi-wayland.nix
    ./user/sessionVariables.nix
    ./user/spicetify.nix
    ./user/sxhkd.nix
    ./user/theming.nix
    ./user/xdg.nix
    ./user/xorg.nix
    ./user/zsh.nix
  ];
}
