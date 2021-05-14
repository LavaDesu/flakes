self: super: {
  linux-lava = super.linuxPackagesFor ((super.linuxManualConfig {
    inherit (super) lib stdenv;
    version = "5.11.20-lqx-Lava";
    allowImportFromDerivation = true;
    configfile = ./kernel.config;
    isZen = true;

    src = builtins.fetchurl {
      url = "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.11.tar.xz";
      sha256 = "1d37w0zvmf8c1l99xvy1hy6p55icjhmbsv7f0amxy2nly1a7pw04";
    };
    kernelPatches = [
      {
        name = "20-lqx1";
        patch = builtins.fetchurl {
          url = "https://github.com/zen-kernel/zen-kernel/releases/download/v5.11.20-lqx1/v5.11.20-lqx1.patch.xz";
          sha256 = "0ff6w8xr3v85gqmdg0qk04hf34rnz4dkvd8xxyvkw78dkjfm4aqm";
        };
      }
      {
        name = "amd";
        patch = builtins.fetchurl {
          url = "https://gist.githubusercontent.com/LavaDesu/98997b93ced7337ef3b6b12c4fc4d9dd/raw/7fe92260c2af90a405ff4c3153707a12664d8dd2/0001-Lava-s-amdgpu-patches.patch";
          sha256 = "09vf2scckw2blw75ggyjqk432x33vym6qyjhy61w5zpbgmm75lql";
        };
      }
      {
        name = "no-extver";
        patch = builtins.fetchurl {
          url = "https://gist.githubusercontent.com/LavaDesu/98997b93ced7337ef3b6b12c4fc4d9dd/raw/89778e6256bc224abca16943c18f2f961286b941/0001-Remove-EXTRAVERSION.patch";
          sha256 = "03rrl1dns9r0nq0qmlmxazi4rxgrbflxzzgr1hmlp75ypcy9izyv";
        };
      }
      {
        name = "winesync";
        patch = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/master/linux-tkg-patches/5.11/0007-v5.11-winesync.patch";
          sha256 = "0lf374ccxhhr8idb8kbpzxzw7pi4s4ghdvnffp4pd6q56qs5j86j";
        };
      }
      {
        name = "bcachefs";
        patch = builtins.fetchurl {
          url = "https://raw.githubusercontent.com/Frogging-Family/linux-tkg/master/linux-tkg-patches/5.11/0008-5.11-bcachefs.patch";
          sha256 = "06b3c6k56i5zqgmh5i3rixhz7mhq187cckkcnxb7d2g4vxy1v0vc";
        };
      }
    ];
  }).overrideAttrs(o: {
    passthru = o.passthru // {
      features = {
        efiBootStub = true;
        ia32Emulation = true;
      };
    };
  }));
}
