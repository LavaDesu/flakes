self: super: {
  polymc = super.polymc.overrideAttrs(_: rec {
    version = "1.1.0";

    src = self.fetchFromGitHub {
        owner = "PolyMC";
        repo = "PolyMC";
        rev = version;
        sha256 = "sha256-p5vbpNZI/JiQJclEo/Pu/46qVul+3DAzaoow8jabHrI=";
        fetchSubmodules = true;
    };
  });
}