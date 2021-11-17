# Flake for development on https://github.com/ppy/osu-web
{
  mkShell,
  nodejs-14_x,
  nodePackages,
  php80,
  php80Packages,
  python3
}:
let
  phpPkg = php80.withExtensions ({ enabled, all }:
    enabled ++ [ all.intl all.redis ]
  );
in mkShell {
  buildInputs = [
    nodejs-14_x
    nodePackages.yarn
    phpPkg
    php80Packages.composer
    python3
  ];

  shellHook = ''
    export PATH="$(readlink -f ./node_modules/.bin):$PATH"
  '';
}
