self: { bash, buildFHSEnv, cacert, ncurses5, runCommand, ... } @ super:
let
  drvName = super.android-studio.name;
  fhsEnv = buildFHSEnv {
    name = "${drvName}-fhs-env";
    # google's analytics calls jdk's getOperatingSystemMXBean which tries to parse cgroups and ultimately fails for whatever reason with an npe
    unshareCgroup = false;
    multiPkgs = pkgs: [
      ncurses5

      (runCommand "fedoracert" {}
        ''
        mkdir -p $out/etc/pki/tls/
        ln -s ${cacert}/etc/ssl/certs $out/etc/pki/tls/certs
        '')
    ];
  };

  startScript = ''
    #!${bash}/bin/bash
    ${fhsEnv}/bin/${drvName}-fhs-env ${super.android-studio.passthru.unwrapped}/bin/studio.sh "$@"
  '';
in {
  android-studio-patched = super.android-studio.overrideAttrs(_: {
    inherit startScript;
  });
}
