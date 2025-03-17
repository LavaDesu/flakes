{ ... }: {
  services.xserver = {
    displayManager = {
      xserverArgs = [
        "-ardelay 150"
        "-arinterval 15"
      ];
    };
    xkb.options = "caps:escape";
  };
  services.libinput = {
    enable = true;
    mouse = {
      accelSpeed = "0";
      accelProfile = "flat";
    };
  };
  console.useXkbConfig = true;
}
