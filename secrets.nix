let
  apricot = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGS0M4BOLiVUM/qdUpcg9Y4aTeyDfyQl89uhXwFORjn";
  blossom = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5wfPCcpkNR3ubr7cBV0UwVCDo/sMmV0aI/JOJTIxQj";
  caramel = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIPFJT1XYyjDZFHYT/8RdxAReKkeU8QfpLrmMjEeW/80";
  fondue = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIkKZYsYWnI+MgecBjOwf7aL5jtiT0ymCDme3pzucTei";

  rin-apricot = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxzygMMJ/hmPRUeQu/eMmEhAKfFSFIEVstDIerPzxgZ";
  rin-blossom = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPru5eTBvHJ4ZmrrzPRHCGM09wQP/ZHSaKYalDuBVO15";
  rin-fondue = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKbPamP5bovUsrBNYnjOk4SN2TaQZAVlJ+4JldK2cL5M";
in {
  "secrets/passwd.age".publicKeys = [ apricot caramel fondue blossom rin-apricot rin-fondue rin-blossom ];
  "secrets/wpa_conf.age".publicKeys = [ apricot caramel blossom rin-apricot rin-blossom ];

  "secrets/wg_apricot.age".publicKeys = [ apricot rin-apricot rin-blossom ];
  "secrets/wg_fondue.age".publicKeys = [ fondue rin-fondue rin-blossom ];
  "secrets/wg_blossom.age".publicKeys = [ blossom rin-blossom ];
}
