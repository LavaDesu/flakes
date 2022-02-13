let
  blossom = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5wfPCcpkNR3ubr7cBV0UwVCDo/sMmV0aI/JOJTIxQj";
  caramel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPFJT1XYyjDZFHYT/8RdxAReKkeU8QfpLrmMjEeW/80";
  sugarcane = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImymDDLSOdLcsox8wxS9Z84fsbsz6Mi58OU0od2p/ZQ";

  rin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPru5eTBvHJ4ZmrrzPRHCGM09wQP/ZHSaKYalDuBVO15";
in {
  "secrets/passwd.age".publicKeys = [ blossom caramel sugarcane rin ];
  "secrets/wpa_conf.age".publicKeys = [ blossom caramel rin ];

  "secrets/wg_blossom.age".publicKeys = [ blossom rin ];
  "secrets/wg_caramel.age".publicKeys = [ caramel rin ];
  "secrets/wg_sugarcane.age".publicKeys = [ sugarcane rin ];
}
