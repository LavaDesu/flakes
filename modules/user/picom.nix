{ config, ... }: {
  services.picom = {
    enable = true;

    # blur = true;
    # blurExclude = [
    #   (builtins.concatStringsSep " && " [
    #     "class_g != 'Alacritty'"
    #     "class_g != 'kitty'"
    #     #"class_g != 'Polybar'"
    #     "class_g != 'URxvt'"
    #   ])
    # ];
    fade = true;
    fadeDelta = 5;
    fadeSteps = [ 0.05 0.05 ];

    opacityRules = [
      "80:class_g = 'Alacritty' && !focused"
      "95:class_g = 'kitty' && !focused"
    ];
    vSync = true;

    settings = {
      glx-no-stencil = true;
      glx-copy-from-front = false;
      glx-no-rebind-pixmap = true;
      # https://github.com/yshui/picom/issues/578
      glx-use-copysubbuffer-mesa = false;
      use-damage = true;

      detect-transient = true;
      detect-client-leader = true;
      detect-client-opacity = true;
      detect-rounded-corners = true;
      use-ewmh-active-win = true;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
    };
  };
}
