{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    android-studio
    jetbrains.idea-community-bin
    texliveFull
  ];
}
