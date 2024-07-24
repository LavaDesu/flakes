let
  anemone = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEPFifSAybe97xDP/cq6AAjy7Fm0go0dtQ9ICK6JRUgc";
  blossom = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5wfPCcpkNR3ubr7cBV0UwVCDo/sMmV0aI/JOJTIxQj";
  caramel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPFJT1XYyjDZFHYT/8RdxAReKkeU8QfpLrmMjEeW/80";
  sugarcane = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImymDDLSOdLcsox8wxS9Z84fsbsz6Mi58OU0od2p/ZQ";
  dandelion = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFUk99ku7+eiIO7Q9sIPlPx3GiUljLv7W404W/zwrtzI";

  rin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPru5eTBvHJ4ZmrrzPRHCGM09wQP/ZHSaKYalDuBVO15";
in {
  "secrets/passwd.age".publicKeys = [ anemone blossom caramel sugarcane rin ];
  "secrets/wpa_conf.age".publicKeys = [ blossom caramel rin ];

  "secrets/acme_dns.age".publicKeys = [ dandelion rin ];
  "secrets/warden_admin.age".publicKeys = [ caramel rin ];
  "secrets/wg_blossom.age".publicKeys = [ blossom rin ];
  "secrets/wg_caramel.age".publicKeys = [ caramel rin ];
  "secrets/wg_sugarcane.age".publicKeys = [ sugarcane rin ];
}
