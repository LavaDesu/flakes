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
  console.useXkbConfig = true;
}
