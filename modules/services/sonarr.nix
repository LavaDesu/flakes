{ ... }:
let
  dir = "/persist/sonarr";
in
{
  services.sonarr = {
    enable = true;
    dataDir = dir;
    openFirewall = true;
  };
}
