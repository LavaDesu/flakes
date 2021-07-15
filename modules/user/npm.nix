{ config, pkgs, ... }: {
  xdg.configFile."npm/npmrc".text = ''
    cache=${config.xdg.dataHome}/npm/cache
    prefix=${config.xdg.dataHome}/npm
    store-dir=${config.xdg.dataHome}/npm/pnpm-store
  '';
}
