{ ... }: {
  systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true";
  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    user = "rin";
    group = "users";
    dataDir = "/persist/shared/.syncthing/data";
    configDir = "/persist/shared/.syncthing/config";
    settings = {
      devices = {
        #"anemone".id = "";
      };
      # folders = {
      #   "Obby" = {
      #     path = "/home/rin/Documents/Obby/Obby";
      #     devices = [];
      #   };
      # };
    };
  };
}
