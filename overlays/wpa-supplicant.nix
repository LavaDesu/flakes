self: super: {
  # Thanks https://discourse.nixos.org/t/journal-logs-spammed-with-ctrl-event-scan-failed/56316/5
  wpa_supplicant = super.wpa_supplicant.overrideAttrs(o: {
    patches = o.patches ++ [ ./patches/wpa-supplicant.patch ];
  });
}
