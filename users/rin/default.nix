{ config, pkgs, ... }: {
  users.users.rin = {
    isNormalUser = true;
    extraGroups = [ "audio" "video" "wheel" ];
    shell = pkgs.zsh;
    uid = 1001;
  };
  home-manager.users.rin = import ./home.nix;
}
