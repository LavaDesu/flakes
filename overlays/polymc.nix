self: super: {
  polymc = super.polymc.overrideAttrs(old: rec {
    version = "1.1.0";

    cmakeFlags = old.cmakeFlags ++ [ "-DLauncher_PORTABLE=0" ];

    src = self.fetchFromGitHub {
        owner = "PolyMC";
        repo = "PolyMC";
        rev = version;
        sha256 = "sha256-p5vbpNZI/JiQJclEo/Pu/46qVul+3DAzaoow8jabHrI=";
        fetchSubmodules = true;
    };
  });
}
