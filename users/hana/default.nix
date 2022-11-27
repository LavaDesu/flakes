{ config, lib, modules, pkgs, ... }: {
  users.users.hana = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    uid = 1002;
    passwordFile = config.age.secrets.passwd.path;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPru5eTBvHJ4ZmrrzPRHCGM09wQP/ZHSaKYalDuBVO15 rin@blossom"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ5l9t8dc6mPsKKYqZlPKvhOdyqz+DS5UOcvHuh3uVGt @strawberry"
    ];
  };

  home-manager.users.hana = { config, enableGUI, lib, pkgs, ... }: {
    home = {
      username = "hana";
      homeDirectory = "/home/hana";
      stateVersion = "21.11";
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
