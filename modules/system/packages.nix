{ pkgs, ... }: {
  imports = [ ./packages-gui.nix ];
  environment.systemPackages = with pkgs; [
    comma
    ecryptfs
    efibootmgr
    git
    htop
    jq
    libarchive
    lf
    msr-tools
    ncdu
    neovim
    nfs-utils
    ntfs3g
    sshfs
    rsync
    wget
  ];
  environment.variables.EDITOR = "nvim";
}
