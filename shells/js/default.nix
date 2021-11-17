{
  mkShell,

  nodejs-16_x,
  nodePackages,
  watchman
}:
mkShell {
  buildInputs = [
    nodejs-16_x
    watchman

    nodePackages.pnpm
  ];

  shellHook = ''
    export PATH="$(readlink -f ./node_modules/.bin):$PATH"
  '';
}
