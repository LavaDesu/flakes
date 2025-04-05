{ config, lib, modules, pkgs, ... }: {
  programs.zsh.enable = true;
  users.users.hana = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    uid = 1002;
    hashedPassword = "$y$j9T$3xCNDudmfrIu5VfQQoDkj/$ugzJWq0gORN9jnhDsREu31CkL3zwniQu6KoLbmg6Wr/";
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPru5eTBvHJ4ZmrrzPRHCGM09wQP/ZHSaKYalDuBVO15 rin@anemone"
    ];
  };

  home-manager.users.hana = { config, lib, pkgs, ... }: {
    home = {
      username = "hana";
      homeDirectory = "/home/hana";
      stateVersion = "24.11";
    };

    imports = with modules.user; [
      direnv
      git
      neovim-minimal
      sessionVariables
      zsh
    ];

    programs.git.signing.signByDefault = lib.mkForce false;
    programs.zsh.history.path = lib.mkForce "/persist/hana/zsh_history";
  };
}
