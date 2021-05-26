self: super: {
  linux-lava = super.linuxPackagesFor ((super.linuxManualConfig (
  let
    major = "5";
    minor = "11";
    patch = "21";
    tkg = "467e6c3f41da14ae6f5aa57a1d0490b4244fbce0";

    mm = "${major}.${minor}";
    mmp = "${major}.${minor}.${patch}";

    kernelUrl = name: sha256: builtins.fetchurl {
      inherit sha256;
      url = "https://cdn.kernel.org/pub/linux/kernel/v${major}.x/${name}.xz";
    };

    tkgPatch = name: sha256: {
      inherit name;
      patch = builtins.fetchurl {
        inherit sha256;
        url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/${tkg}/linux-tkg-patches/${mm}/${name}.patch";
      };
    };
  in {
    inherit (super) lib stdenv;
    version = "${mmp}-tkg-Lava";
    allowImportFromDerivation = true;
    configfile = ./misc/kernel.config;
    isZen = true;

    src = kernelUrl "linux-${mm}.tar" "1d37w0zvmf8c1l99xvy1hy6p55icjhmbsv7f0amxy2nly1a7pw04";
    kernelPatches = [
      # Kernel version patch
      {
        name = "patch-${patch}";
        patch = kernelUrl "patch-${mmp}" "0va01x8hb9ny7hrjbq5kviz6awg2d495zs2fn0vswrjkdi18cq7j";
      }

      # AMD SI manual clocking
      {
        name = "amd";
        patch = builtins.fetchurl {
          url = "https://gist.githubusercontent.com/LavaDesu/98997b93ced7337ef3b6b12c4fc4d9dd/raw/7fe92260c2af90a405ff4c3153707a12664d8dd2/0001-Lava-s-amdgpu-patches.patch";
          sha256 = "09vf2scckw2blw75ggyjqk432x33vym6qyjhy61w5zpbgmm75lql";
        };
      }

      # Graysky gcc patches
      {
        name = "graysky-gcc";
        patch = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/graysky2/kernel_gcc_patch/d2e7942c19ee568638d3795cf52db5274a90ce0a/more-uarches-for-kernel-5.8+.patch";
          sha256 = "16jbknjlg12jxbj8cjkk01djvr01n9zz7qlzxppcqizmz55vk0wh";
        };
      }

      # TK-Glitch patches
      ( tkgPatch "0002-clear-patches"           "1h1gx6rq2c961d36z1szqv9xpq1xgz2bhqjsyb03jjdrdzlcv9rm" )
      ( tkgPatch "0003-glitched-base"           "1dg177i3y54z5nadc5678hm67angram2vlr314mpxv3jgsh7vj8s" )
      ( tkgPatch "0005-glitched-pds"            "0833awp8n9ngyl5spx8znwyw1lj3nacp8vg7ffysw0j5r8akv9pw" )
      ( tkgPatch "0007-v${mm}-fsync"            "0mplwdglw58bmkkxix4ccwgax3r02gahax9042dx33mybdnbl0mk" )
      ( tkgPatch "0007-v${mm}-futex2_interface" "15jl2h9fgj9ic93nj5xypmg2f97nl8lwgdgdbkdspacanj57ngh7" )
      ( tkgPatch "0007-v${mm}-winesync"         "0lf374ccxhhr8idb8kbpzxzw7pi4s4ghdvnffp4pd6q56qs5j86j" )
      ( tkgPatch "0008-${mm}-bcachefs"          "06b3c6k56i5zqgmh5i3rixhz7mhq187cckkcnxb7d2g4vxy1v0vc" )
      ( tkgPatch "0009-prjc_v${mm}-r3"          "0q40p9rn6dh3dr2wsmfn15zi33pbjbb7pi0i8fgz85x5wcvlkmjw" )
    ];
  })).overrideAttrs(o: {
    passthru = o.passthru // {
      features = {
        efiBootStub = true;
        ia32Emulation = true;
      };
    };
  }));
}
