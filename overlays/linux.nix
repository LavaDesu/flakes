self: super: {
  linux-lava = super.buildLinux (
  let
    major = "5";
    minor = "12";
    patch = "8";
    tkg = "6006c78ceaae9ca344682db51d225576a4ff9914";

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
    version = "${mmp}-tkg-Lava";
    isZen = true;
    structuredExtraConfig = with super.lib.kernel; {
      LOCALVERSION = freeform "-tkg-Lava";
      ZENIFY = yes;
      FUTEX2 = yes;
      SCHED_ALT = yes;
      SCHED_PDS = yes;
      MHASWELL = yes;
      NO_HZ = yes;
      NO_HZ_IDLE = yes;
      HZ_100 = yes;
      WINESYNC = yes;
    };
    ignoreConfigErrors = true;

    src = kernelUrl "linux-${mm}.tar" "0rn3z942vjc7bixjw066rm6kcr0x0wzgxqfq1f6xd113pzrgc3bx";
    kernelPatches = [
      # Kernel version patch
      {
        name = "patch-${patch}";
        patch = kernelUrl "patch-${mmp}" "0pjkddh40irbmhh24yfxjl46dwc0plpm8mz5mg5q84937b23kkx6";
      }

      # AMD SI manual clocking
      {
        name = "amd";
        patch = ./misc/0001-Lava-s-amdgpu-patches.patch;
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
      ( tkgPatch "0007-v${mm}-futex2_interface" "1j29zyx2s85scfhbprgb9cs11rp50glbzczl4plphli8wds342pw" )
      ( tkgPatch "0007-v${mm}-winesync"         "1q82439450bldni0lra9hmhvdxnjxxhlv8v95kd36wah7fki4k83" )
      ( tkgPatch "0009-prjc_v${mm}-r1"          "1z731jiwyc7z4d5hzd6szrxnvw0iygbqx82y2anzm32n22731dqv" )
    ];
  });
}
