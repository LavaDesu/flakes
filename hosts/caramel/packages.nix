{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    git
    htop
    jq
    neovim
    rsync
    sshfs
    wget
  ];
  environment.variables.EDITOR = "nvim";
}
