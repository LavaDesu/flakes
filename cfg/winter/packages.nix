{ config, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    git libarchive lf msr-tools neofetch neovim nodejs rsync wget
    gnupg
    glxinfo htop light ncdu xorg.xgamma
    alacritty discord-canary element-desktop firefox gnome3.nautilus pavucontrol tor-browser-bundle-bin
    wine-osu (winetricks.override { wine = wine-osu; })

    (pkgs.writeShellScriptBin "nix-flakes" ''
      exec ${pkgs.nixUnstable}/bin/nix --experimental-features "nix-command flakes" "$@"
    '')
  ];
  hardware.opentabletdriver.enable = true;
  environment.variables.EDITOR = "nvim";
  programs.steam.enable = true;
  services.gnome.sushi.enable = true;
  services.ipfs.enable = true;
}
