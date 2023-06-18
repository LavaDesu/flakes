{
  mkShell,

  nodejs-18_x,
  nodePackages,
  watchman
}:
mkShell {
  buildInputs = [
    nodejs-18_x
    watchman

    nodePackages.pnpm
  ];

  shellHook = ''
    export PATH="$(readlink -f ./node_modules/.bin):$PATH"
  '';
}
