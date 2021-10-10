{ inputs
, buildGoModule
}:
buildGoModule {
  pname = "packwiz";
  version = inputs.packwiz.shortRev;
  src = inputs.packwiz;
  vendorSha256 = "1f2xh8czq8fh823dyp54rdv5mmb9gf62f5fimdah4wmghqw4wbzy";
}
