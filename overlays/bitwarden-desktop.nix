# https://github.com/NixOS/nixpkgs/pull/374068
self: super: {
  bitwarden-desktop = super.bitwarden-desktop.overrideAttrs (o: {
    preBuild = o.preBuild + ''
      pushd apps/desktop/desktop_native/proxy
      cargo build --offline --bin desktop_proxy --release
      popd
    '';
    installPhase = builtins.replaceStrings ["runHook preInstall"] [''
      runHook preInstall

      install -Dm755 -t $out/bin apps/desktop/desktop_native/target/release/desktop_proxy

      mkdir -p $out/lib/mozilla/native-messaging-hosts
      substituteAll ${./patches/firefox-native-messaging-host.json} $out/lib/mozilla/native-messaging-hosts/com.8bit.bitwarden.json

    ''] o.installPhase;
  });
}
