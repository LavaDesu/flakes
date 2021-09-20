let
  apricot = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIGGS0M4BOLiVUM/qdUpcg9Y4aTeyDfyQl89uhXwFORjn";
  fondue = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIkKZYsYWnI+MgecBjOwf7aL5jtiT0ymCDme3pzucTei";
  winter = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA5wfPCcpkNR3ubr7cBV0UwVCDo/sMmV0aI/JOJTIxQj";

  rin-apricot = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxzygMMJ/hmPRUeQu/eMmEhAKfFSFIEVstDIerPzxgZ";
  rin-fondue = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKbPamP5bovUsrBNYnjOk4SN2TaQZAVlJ+4JldK2cL5M";
  rin-winter = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPru5eTBvHJ4ZmrrzPRHCGM09wQP/ZHSaKYalDuBVO15";
in {
  "secrets/passwd.age".publicKeys = [ apricot fondue winter rin-apricot rin-fondue rin-winter ];
  "secrets/wpa_conf.age".publicKeys = [ apricot winter rin-apricot rin-winter ];

  "secrets/wg_apricot.age".publicKeys = [ apricot rin-apricot rin-winter ];
  "secrets/wg_fondue.age".publicKeys = [ fondue rin-fondue rin-winter ];
  "secrets/wg_winter.age".publicKeys = [ winter rin-winter ];
}
