{ buildLinux
, callPackage
, kernelPatches
, lib
, ...
} @ args:

let
  sources = callPackage ./sources.nix {};
in buildLinux (args // {
  inherit (sources) src kernelPatches;
  version = "${sources.version}-tkg-Lava";
  isZen = true;
  # TODO:
  # some stuff is set in pkgs/os-specific/linux/kernel/common-config.nix
  # but i have no idea how to change it
  structuredExtraConfig = with lib.kernel; builtins.mapAttrs (_: value: lib.mkForce value) {
    LOCALVERSION = freeform "-tkg-Lava";
    ZENIFY = yes;
    FUTEX2 = yes;
    MHASWELL = yes;
    WINESYNC = module;

    # tickless timers
    HZ_PERIODIC = no;
    NO_HZ = yes;
    NO_HZ_COMMON = yes;
    NO_HZ_FULL = yes;
    NO_HZ_FULL_NODEF = yes;
    NO_HZ_IDLE = no;
    CONTEXT_TRACKING = yes;
    CONTEXT_TRACKING_FORCE = no;
    HZ_2000 = yes;
    HZ_2000_NODEF = yes;

    # preempt
    PREEMPT = yes;
    PREEMPT_COUNT = yes;
    PREEMPT_VOLUNTARY = no;
    PREEMPTION = yes;
    PREEMPT_DYNAMIC = yes;

    # scheduler
    CACULE_SCHED = yes;
    SCHED_AUTOGROUP = yes;
    BSD_PROCESS_ACCT = no;
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

    # disable ftrace
    FUNCTION_TRACER = no;
    FUNCTION_GRAPH_TRACER = no;

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
} // (args.argsOverride or {}))
