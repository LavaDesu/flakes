{ config, lib, modules, pkgs, ... }: {
  users.users.hana = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    uid = 1002;
    passwordFile = config.age.secrets.passwd.path;
  };

  home-manager.users.hana = { config, enableGUI, lib, pkgs, ... }: {
    home = {
      username = "hana";
      homeDirectory = "/home/hana";
      stateVersion = "21.11";
      keyboard = null; # see https://github.com/nix-community/home-manager/issues/2219
    };

    imports = with modules.user; [
      direnv
      git
      neovim-minimal
      sessionVariables
      zsh
    ];

    programs.git.signing.signByDefault = lib.mkForce false;
    programs.zsh.history.path = lib.mkForce "/nix/persist/hana/zsh_history";

    home.file.".ssh/authorized_keys".source = config.lib.file.mkOutOfStoreSymlink "/nix/persist/hana/authorized_keys";
  };
}
