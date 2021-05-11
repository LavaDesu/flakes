{ config, pkgs, ...}: {
  powerManagement.cpuFreqGovernor = "performance";
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    blacklistedKernelModules = [
      "uvcvideo"
    ];
    initrd = {
      includeDefaultModules = false;
      kernelModules = [ "i915" ];
    };
    kernel.sysctl = {
      "kernel.sysrq" = 1;
    };
    kernelParams = [
      "amdgpu.gpu_recovery=1"
      "amdgpu.si_support=1"
      "radeon.si_support=0"
      "intel_pstate=passive"
    ];
    kernelPackages = pkgs.linuxPackagesFor (pkgs.linuxManualConfig {
      inherit (pkgs) lib stdenv;
      #stdenv = pkgs.ccacheStdenv;
      version = "5.11.19-lqx-Lava";
      allowImportFromDerivation = true;
      configfile = ./kernel.config;
      isZen = true;

      src = builtins.fetchurl {
        url = "https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.11.tar.xz";
        sha256 = "1d37w0zvmf8c1l99xvy1hy6p55icjhmbsv7f0amxy2nly1a7pw04";
      };
      kernelPatches = [
        {
          name = "19-lqx1";
          patch = builtins.fetchurl {
            url = "https://github.com/zen-kernel/zen-kernel/releases/download/v5.11.19-lqx1/v5.11.19-lqx1.patch.xz";
            sha256 = "15js72w0fnikdmiwhnh3ks3gdbdsng7zjhriirxbdkj3k1y8r7va";
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
            url = "https://gist.githubusercontent.com/LavaDesu/98997b93ced7337ef3b6b12c4fc4d9dd/raw/7fe92260c2af90a405ff4c3153707a12664d8dd2/0001-Remove-EXTRAVERSION.patch";
            sha256 = "0yc1knzn5nq4dw0n3x0467rv4rdh9pmfz593w1cy5n642ivm8lac";
          };
        }
      ];
    });
  };
  # programs.ccache = {
  #   enable = true;
  #   cacheDir = "/var/cache/ccache";
  #   packageNames = ["dummy"];
  # };
}
