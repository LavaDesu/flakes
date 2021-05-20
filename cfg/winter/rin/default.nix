{ config, pkgs, ... }: {
  users.users.rin = {
    isNormalUser = true;
    extraGroups = [ "audio" "video" "wheel" ];
    shell = pkgs.zsh;
  };
}
