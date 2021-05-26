{ config, pkgs, ... }:
let
  lib = pkgs.lib;

  abbrs = {
    e = "$EDITOR";
    rs = "source ~/.config/zsh/.zshrc";

    ll = "ls -al";
    q = "exit";

    peach = "ssh lava@peach";
    bunny = "ssh bunny@peach";

    fa = "grep -Inr";
    fai = "grep -Iinr";

    g1 = "xgamma -gamma 1";
    g3 = "xgamma -gamma 1.3";

    bat = "echo 'battery' | doas tee /sys/class/drm/card1/device/power_dpm_state";
    bal = "echo 'balanced' | doas tee /sys/class/drm/card1/device/power_dpm_state";
    sclk = "doas setclock 50000 70000 800";

    sysu = "doas systemctl restart";
    sysd = "doas systemctl stop";
    syss = "doas systemctl status";
    usysu = "systemctl --user restart";
    usysd = "systemctl --user stop";
    usyss = "systemctl --user status";
    j = "doas journalctl -b";
    jf = "doas journalctl -f";

    fl = "cd ~/Projects/flakes";
    nr = "doas nixos-rebuild switch --flake .#winter -v";

    gs = "git status";
    ga = "git add .";
    gc = "git commit";
    gac = "git add .; git commit";
    gcm = "git commit -m";
    gco = "git checkout";
    gd = "git diff";
    gf = "git commit --amend --no-edit";
    gl = "git log";
    gr = "git rebase -i";
  };

  genAbbrs = lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "abbr add -S --quiet ${k}=${lib.escapeShellArg v}") abbrs);
  cursorShape = ''
    function zle-keymap-select {
      if [[ $KEYMAP == vicmd ]] ||
         [[ $1 = 'block' ]]; then
        echo -ne '\e[1 q'
      elif [[ $KEYMAP == main ]] ||
           [[ $KEYMAP == viins ]] ||
           [[ $KEYMAP = "" ]] ||
           [[ $1 = 'beam' ]]; then
        echo -ne '\e[5 q'
      fi
    }
    zle -N zle-keymap-select
    zle-line-init() {
        zle -K viins
        echo -ne "\e[5 q"
    }
    zle -N zle-line-init
    echo -ne '\e[5 q'
    preexec() { echo -ne '\e[5 q' ;}
  '';
  direnv = ''
    eval "$(direnv hook zsh)"
  '';
  viExtraNav = ''
    bindkey -M menuselect 'h' vi-backward-char
    bindkey -M menuselect 'k' vi-up-line-or-history
    bindkey -M menuselect 'l' vi-forward-char
    bindkey -M menuselect 'j' vi-down-line-or-history

    bindkey -v '^?' backward-delete-char
    bindkey -v '^R' history-incremental-pattern-search-backward
    bindkey '^[[A' history-substring-search-up
    bindkey '^[[B' history-substring-search-down
    bindkey -M vicmd 'k' history-substring-search-up
    bindkey -M vicmd 'j' history-substring-search-down
  '';
in rec {
  programs.zsh = {
    enable = true;
    dotDir = ".config/zsh";

    enableAutosuggestions = true;
    autocd = true;
    defaultKeymap = "viins";

    history = {
      extended = true;
      path = "${config.xdg.dataHome}/zsh/history";
      save = 10000000;
      size = 10000000;
    };

    enableCompletion = true;
    initExtraBeforeCompInit = ''
      zstyle ':completion:*' completer _complete
      zstyle ':completion:*' matcher-list "" 'm:{[:lower:][:upper:]-_}={[:upper:][:lower:]_-}' '+l:|=* r:|=*'
      zstyle ':completion:*' menu select
      _comp_options+=(globdots)
      zmodload zsh/complist
    '';

    sessionVariables = {
      WINEPREFIX = "${config.xdg.dataHome}/wine64";
      WINEARCH = "win64";

      EDITOR = "nvim";
      PATH = "${config.xdg.dataHome}/npm/bin:$PATH";
      DIRENV_LOG_FORMAT = "";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
    };
    localVariables = {
      PS1 = "%B%{$fg[red]%}[%{$fg[yellow]%}%n%{$fg[green]%}@%{$fg[blue]%}%M %{$fg[magenta]%}%~%{$fg[red]%}]%{$reset_color%}$%b ";
      ZSH_AUTOSUGGEST_STRATEGY = ["completion"];
      ZSH_AUTOSUGGEST_USE_ASYNC = true;
      ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE = 40;
    };

    shellAliases = {
      ls = "ls --color=tty -v";
      diff = "diff -Naur --color=always";
    };
    initExtraFirst = ''
      autoload -U colors && colors
    '';
    initExtra = lib.concatStringsSep "\n" [
      cursorShape
      direnv
      genAbbrs
      viExtraNav
    ];

    plugins = [
      {
        name = "zsh-abbr";
        src = pkgs.fetchFromGitHub {
          owner = "olets";
          repo = "zsh-abbr";
          rev = "99af0455b7b86ff3894a4bcf73380be2d595fa54";
          sha256 = "014zvikfqqcv40x24h60ad3vyjz6kf9f7xhkk6iz7qyxwgcs90zs";
        };
      }
      {
        name = "zsh-history-substring-search";
        src = pkgs.fetchFromGitHub {
          owner = "zsh-users";
          repo = "zsh-history-substring-search";
          rev = "0f80b8eb3368b46e5e573c1d91ae69eb095db3fb";
          sha256 = "0y8va5kc2ram38hbk2cibkk64ffrabfv1sh4xm7pjspsba9n5p1y";
        };
      }
      {
        name = "fast-syntax-highlighting";
        src = pkgs.fetchFromGitHub {
          owner = "zdharma";
          repo = "fast-syntax-highlighting";
          rev = "817916dfa907d179f0d46d8de355e883cf67bd97";
          sha256 = "0m102makrfz1ibxq8rx77nngjyhdqrm8hsrr9342zzhq1nf4wxxc";
        };
      }
    ];
  };
}
