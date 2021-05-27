{ config, ... }: {
  services.picom = {
    enable = true;
    experimentalBackends = true;

    blur = true;
    blurExclude = [
      "class_g != 'Alacritty' && class_g != 'Polybar'"
    ];
    fade = true;
    fadeDelta = 5;
    fadeSteps = [ "0.05" "0.05" ];

    opacityRule = [
      "80:class_g = 'Alacritty' && !focused"
    ];
    vSync = true;

    extraOptions = ''
      glx-no-stencil = true;
      glx-copy-from-front = false;
      glx-no-rebind-pixmap = true;
      use-damage = true;

      blur-method = "dual_kawase";
      blur-strength = 5;

      detect-transient = true;
      detect-client-leader = true;
      detect-client-opacity = true;
      detect-rounded-corners = true;
      use-ewmh-active-win = true;
      mark-wmwin-focused = true;
      mark-ovredir-focused = true;
    '';
  };
}
