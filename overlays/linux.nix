self: super: {
  linux-lava = super.buildLinux (
  let
    major = "5";
    minor = "12";
    patch = "10";
    tkg = "2da317c20ed6f70085b195639b9aad2cacf31ab5";

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
    # TODO:
    # some stuff is set in pkgs/os-specific/linux/kernel/common-config.nix
    # but i have no idea how to change it
    structuredExtraConfig = with super.lib.kernel; builtins.mapAttrs (_: value: super.lib.mkForce value) {
      LOCALVERSION = freeform "-tkg-Lava";
      ZENIFY = yes;
      FUTEX2 = yes;
      MHASWELL = yes;
      WINESYNC = module;

      # timers
      HZ_PERIODIC = no;
      NO_HZ = yes;
      NO_HZ_COMMON = yes;
      NO_HZ_FULL = yes;
      NO_HZ_IDLE = no;
      CONTEXT_TRACKING = yes;
      CONTEXT_TRACKING_FORCE = yes;
      # HZ_100 = yes;
      HZ_1000 = yes;
      HZ_1000_NODEF = yes;

      # scheduler
      # SCHED_ALT = yes;
      # SCHED_PDS = yes;
      CACULE_SCHED = yes;

      # cacule stuff
      SCHED_AUTOGROUP = yes;
      BSD_PROCESS_ACCT = no;
      TASK_XACCT = no;
      CGROUP_CPUACCT = no;
      CGROUP_DEBUG = no;

      # disable numa
      NUMA = no;
      AMD_NUMA = no;
      X86_64_ACPI_NUMA = no;
      NODES_SPAN_OTHER_NODES = no;
      NUMA_EMU = no;
      NEED_MULTIPLE_NODES = no;
      USE_PERCPU_NUMA_NODE_ID = no;
      ACPI_NUMA = no;

      # disable misc debugging
      SLUB_DEBUG = no;
      PM_DEBUG = no;
      PM_ADVANCED_DEBUG = no;
      PM_SLEEP_DEBUG = no;
      ACPI_DEBUG = no;
      SCHED_DEBUG = no;
      LATENCYTOP = no;
      DEBUG_PREEMPT = no;
    };
    ignoreConfigErrors = true;

    src = kernelUrl "linux-${mm}.tar" "0rn3z942vjc7bixjw066rm6kcr0x0wzgxqfq1f6xd113pzrgc3bx";
    kernelPatches = [
      # Kernel version patch
      {
        name = "patch-${patch}";
        patch = kernelUrl "patch-${mmp}" "1s0430sbfbfmm225xazvhl8ln33qq81qp0r2wdw5b4azw9xyqi5q";
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
      ( tkgPatch "0003-cacule-${mm}"            "1rgdk1x514xsjwcjjcdmggbaj6biql5p41skn98ysqbjaw7k22ib" )
      ( tkgPatch "0003-glitched-base"           "1dg177i3y54z5nadc5678hm67angram2vlr314mpxv3jgsh7vj8s" )
      ( tkgPatch "0003-glitched-cfs"            "1cm4s72pymxnh37da84qrzvrwbbwagk46m1xsk99ir7cjb1l1zay" )
      # ( tkgPatch "0005-glitched-pds"            "0833awp8n9ngyl5spx8znwyw1lj3nacp8vg7ffysw0j5r8akv9pw" )
      ( tkgPatch "0007-v${mm}-fsync"            "0mplwdglw58bmkkxix4ccwgax3r02gahax9042dx33mybdnbl0mk" )
      ( tkgPatch "0007-v${mm}-futex2_interface" "1j29zyx2s85scfhbprgb9cs11rp50glbzczl4plphli8wds342pw" )
      ( tkgPatch "0007-v${mm}-winesync"         "1av2k86ns0zc3lmgbfdch1z2a808brp2jvsfl4cwwlwwb51qzipp" )
      # ( tkgPatch "0009-prjc_v${mm}-r1"          "1z731jiwyc7z4d5hzd6szrxnvw0iygbqx82y2anzm32n22731dqv" )
      ( tkgPatch "0012-misc-additions"          "092ws9v1snk61i6x3gbqm5m803zd81wykkdxizn7knvy2r611cbz")
    ];
  });
}
