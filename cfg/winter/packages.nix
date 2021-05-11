{ config, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git neofetch neovim nodejs rsync wget
    gnupg
    light glxinfo
    alacritty discord-canary element-desktop firefox pavucontrol tor-browser-bundle-bin

    (pkgs.writeShellScriptBin "nix-flakes" ''
      exec ${pkgs.nixUnstable}/bin/nix --experimental-features "nix-command flakes" "$@"
    '')
  ];
}
