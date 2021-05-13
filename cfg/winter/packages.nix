{ config, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git lf neofetch neovim nodejs rsync wget
    gnupg
    light glxinfo
    alacritty discord-canary element-desktop firefox gnome3.nautilus pavucontrol tor-browser-bundle-bin

    (pkgs.writeShellScriptBin "nix-flakes" ''
      exec ${pkgs.nixUnstable}/bin/nix --experimental-features "nix-command flakes" "$@"
    '')
  ];
  programs.steam.enable = true;
  services.gnome.sushi.enable = true;
  services.ipfs.enable = true;
}
