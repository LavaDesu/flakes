let
  apricot = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGS0M4BOLiVUM/qdUpcg9Y4aTeyDfyQl89uhXwFORjn";
  blossom = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5wfPCcpkNR3ubr7cBV0UwVCDo/sMmV0aI/JOJTIxQj";
  caramel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPFJT1XYyjDZFHYT/8RdxAReKkeU8QfpLrmMjEeW/80";
  fondue = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIkKZYsYWnI+MgecBjOwf7aL5jtiT0ymCDme3pzucTei";
  sugarcane = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIImymDDLSOdLcsox8wxS9Z84fsbsz6Mi58OU0od2p/ZQ";

  rin = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPru5eTBvHJ4ZmrrzPRHCGM09wQP/ZHSaKYalDuBVO15";
in {
  "secrets/passwd.age".publicKeys = [ apricot blossom caramel fondue sugarcane rin ];
  "secrets/wpa_conf.age".publicKeys = [ apricot blossom caramel rin ];

  "secrets/wg_apricot.age".publicKeys = [ apricot rin ];
  "secrets/wg_blossom.age".publicKeys = [ blossom rin ];
  "secrets/wg_fondue.age".publicKeys = [ fondue rin ];
}
