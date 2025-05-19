let
  anemone = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEPFifSAybe97xDP/cq6AAjy7Fm0go0dtQ9ICK6JRUgc";
  blossom = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5wfPCcpkNR3ubr7cBV0UwVCDo/sMmV0aI/JOJTIxQj";
  hazel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ6mi50ecrrMIn5C4QUyCjPHfSElz0mhevvFCznUzIrK";

  rin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPru5eTBvHJ4ZmrrzPRHCGM09wQP/ZHSaKYalDuBVO15";
in {
  "secrets/passwd.age".publicKeys = [ anemone blossom rin ];
  "secrets/wpa_conf.age".publicKeys = [ blossom rin ];

  "secrets/acme_dns.age".publicKeys = [ hazel rin ];
  "secrets/warden_admin.age".publicKeys = [ rin ];
  "secrets/wg_blossom.age".publicKeys = [ blossom rin ];
  "secrets/wg_caramel.age".publicKeys = [ rin ];
  "secrets/wg_sugarcane.age".publicKeys = [ rin ];
}
