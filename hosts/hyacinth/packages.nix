{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    jetbrains.idea-community-bin
    texliveFull
  ];
}
