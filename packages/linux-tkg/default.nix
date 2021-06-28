# FIXME: This entire derivation is extremely ugly.
{
  buildLinux
, fetchFromGitHub
, lib
, extraConfig ? {}
, kernelPatches ? []

, version ? "5.12"
, debug ? true
, tcpAlgorithm ? "cubic"
, scheduler ? "cfs"
, runqueueSharing ? "smt"
, timerFreq ? 500
, defaultGovernor ? "ondemand"
, ftrace ? true
, numa ? true
, tickless ? 2

, enableAnbox ? false
, bcachefs ? false
, futex2 ? true
, winesync ? true
, irqThreading ? false
, randomTrustCPU ? false
, smtNice ? true
, zenify ? true

# TODO: yieldType
, yieldType ? 1
# TODO: rrInterval
, rrInterval ? 0

, acsOverride ? false
, aggressiveOndemand ? true
, fsync ? true
, miscAdditions ? true
, zfsFix ? (lib.versionOlder version "5.11")

, localVersion ? ""

, ...
} @ args:
let
  tkg = "2da317c20ed6f70085b195639b9aad2cacf31ab5";

  majorVersion =
    if lib.versions.major version == "5"
    then "5"
    else throw "Unsupported major version";
  minorVersion = lib.versions.minor version;
  patchVersion =
         if minorVersion == "4" then "128"
    else if minorVersion == "10" then "46"
    else if minorVersion == "12" then "13"
    else throw "Unsupported minor version";

  mmp = "${majorVersion}.${minorVersion}.${patchVersion}";
  mm = "${majorVersion}.${minorVersion}";

  kernelUrl = name: sha256: builtins.fetchurl {
    inherit sha256;
    url = "https://cdn.kernel.org/pub/linux/kernel/v${majorVersion}.x/${name}.xz";
  };

  tkgSource = fetchFromGitHub {
    owner = "Frogging-Family";
    repo = "linux-tkg";
    rev = "2da317c20ed6f70085b195639b9aad2cacf31ab5";
    sha256 = "06a5fpafids8nc550pcsyvar2igphi6bpghqzl6cp48hg6p2g07w";
  };

  boolToKernel = bool: with lib.kernel; if bool then yes else no;
  boolToKernelMod = bool: with lib.kernel; if bool then module else no;
  mapBoolToKernel = bool: list: builtins.listToAttrs (
    builtins.map (e: {
      name = e;
      value = boolToKernel bool;
    }) list
  );
  mapNo = list: mapBoolToKernel false list;
  mapYes = list: mapBoolToKernel true list;
  mapNY = list:
       (mapNo (builtins.elemAt list 0)
    // mapYes (builtins.elemAt list 1));

  supportedSchedulers = {
    "5.4" = [ "bmq" "cfs" "cacule" "muqss" "pds" ];
    "5.10" = [ "bmq" "cfs" "cacule" "muqss" "pds" "upds" ];
    "5.12" = [ "bmq" "cfs" "cacule" "muqss" "pds" ];
  };

  # do not put rec please kthx
  tkgConfig = with lib.kernel; {
    defaults = let
      base = {
        # openrgb
        I2C_NCT6775 = module;
        ZSWAP_COMPRESSOR_DEFAULT = freeform "lz4";
      } // mapNY [
        [ "DYNAMIC_FAULT" "DEFAULT_FQ_CODEL" "NTP_PPS" "CPU_FREQ_DEFAULT_GOV_PERFORMANCE_NODEF" "ZSWAP_COMPRESSOR_DEFAULT_LZO" "CMDLINE_OVERRIDE" "X86_P6_NOP" "CPU_FREQ_DEFAULT_GOV_ONDEMAND" "CPU_FREQ_DEFAULT_GOV_CONSERVATIVE" "DEBUG_INFO" "PREEMPT_VOLUNTARY" ]
        [ "DEFAULT_CAKE" "CRYPTO_LZ4" "CRYPTO_LZ4HC" "LZ4_COMPRESS" "LZ4HC_COMPRESS" "ZSWAP_COMPRESSOR_DEFAULT_LZ4" "CMDLINE_BOOL" "TCP_CONG_ADVANCED" "PREEMPT" "PREEMPT_COUNT" "PREEMPTION" "PREEMPT_DYNAMIC" ]
      ];
      extras = {
        "5.4" = {
          TP_SMAPI = module;
          RAID6_USE_PREFER_GEN = yes;
          RCU_BOOST_DELAY = freeform 0;
        };
      };
    in base // (if builtins.hasAttr mm extras then extras.${mm} else {});

    debug =
      if debug
      then mapNo [ "SLUB_DEBUG" "PM_DEBUG" "PM_ADVANCED_DEBUG" "PM_SLEEP_DEBUG" "ACPI_DEBUG" "SCHED_DEBUG" "LATENCYTOP" "DEBUG_PREEMPT" ]
      else {};

    tcpAlgorithm = let
      algorithms = [ "yeah" "bbr" "cubic" "vegas" "westwood" "reno" ];
      base = mapBoolToKernel false (builtins.map(e: "DEFAULT_${lib.toUpper e}") algorithms)
        // mapBoolToKernel true (builtins.map(e: "TCP_CONG_${lib.toUpper e}") algorithms);
    in
      if builtins.elem tcpAlgorithm algorithms
      then base // {
        "DEFAULT_${lib.toUpper tcpAlgorithm}" = yes;
        DEFAULT_TCP_CONG = freeform tcpAlgorithm;
      }
      else throw "Unsupported TCP algorithm";

    scheduler = let
      schedConfigs = {
        cfs = {};
        cacule = mapNY [
          [ "BSD_PROCESS_ACCT" "TASK_XACCT" "CGROUP_CPUACCT" "CGROUP_DEBUG" ]
          [ "CACULE_SCHED" "SCHED_AUTOGROUP" ]
        ];
        muqss = mapNY [
          [ "CFS_BANDWIDTH" "FAIR_GROUP_SCHED" ]
          [ "SCHED_MUQSS" ]
        ];
        pds = mapNY [
          [ "CFS_BANDWIDTH" "FAIR_GROUP_SCHED" "SCHED_BMQ" ]
          [ "SCHED_ALT" "SCHED_PDS" ]
        ];
        bmq = mapNY [
          [ "CFS_BANDWIDTH" "FAIR_GROUP_SCHED" "SCHED_PDS" ]
          [ "SCHED_ALT" "SCHED_BMQ" ]
        ];
        upds = mapNY [
          [ "CFS_BANDWIDTH" "FAIR_GROUP_SCHED" ]
          [ "SCHED_PDS" ]
        ];
      };
    in
      if builtins.hasAttr scheduler schedConfigs
      then
        if builtins.elem scheduler supportedSchedulers.${mm}
        then schedConfigs.${scheduler}
        else throw "Unsupported scheduler for kernel version"
      else throw "Unknown scheduler";

    runqueueSharing = let
      types = [ "none" "smt" "mc" "mc_llc" "smp" "all" ];
      base = mapBoolToKernel false (builtins.map (e: "RQ_${lib.toUpper e}") types);
    in
      if (scheduler == "muqss") then
        if (builtins.elem type types)
        then base // { "RQ_${lib.toUpper type}" = yes; }
        else throw "Unknown runqueueSharing type"
      else {};

    timerFreq = let
      availableFreqs = [100 250 300 500 750 1000]
      ++ lib.optional (scheduler == "cacule") 2000;

      base = mapBoolToKernel false (
        builtins.map (e: "HZ_${builtins.toString e}") availableFreqs
        ++ builtins.map (e: "HZ_${builtins.toString e}_NODEF") availableFreqs
      );
    in
      if builtins.elem timerFreq availableFreqs
      then base // {
        "HZ_${builtins.toString timerFreq}" = yes;
        "HZ_${builtins.toString timerFreq}_NODEF" = yes;
      }
      else throw "Unsupported timer frequency";

    defaultGovernor = let
      governors = {
        schedutil = {};
        performance = mapNY [
          [ "CPU_FREQ_DEFAULT_GOV_SCHEDUTIL" ]
          [ "CPU_FREQ_DEFAULT_GOV_PERFORMANCE" "CPU_FREQ_DEFAULT_GOV_PERFORMANCE_NODEF" ]
        ];
        ondemand = mapNY [
          [ "CPU_FREQ_DEFAULT_GOV_SCHEDUTIL" ]
          [ "CPU_FREQ_DEFAULT_GOV_ONDEMAND" "CPU_FREQ_GOV_ONDEMAND" ]
        ];
      };
    in
      if builtins.hasAttr defaultGovernor governors
      then governors.${defaultGovernor}
      else throw "Unsupported default governor";

    ftrace = mapBoolToKernel ftrace [ "FUNCTION_TRACER" "FUNCTION_GRAPH_TRACER" ];
    numa = if numa then {} else mapNo [ "NUMA" "AMD_NUMA" "ACPI_NUMA" "X86_64_ACPI_NUMA" "NODES_SPAN_OTHER_NODES" "NUMA_EMU" "NODES_SHIFT" "NEED_MULTIPLE_NODES" "USE_PERCPU_NUMA_NODE_ID" ];
    tickless = let
      modes = [
        # Periodic ticks
        (mapNY [
          [ "NO_HZ_FULL_NODEF" "NO_HZ_IDLE" "NO_HZ_FULL" "NO_HZ" "NO_HZ_COMMON" ]
          [ "HZ_PERIODIC" ]
        ])
        # Tickless
        (mapNY [
          [ "HZ_PERIODIC" "NO_HZ_IDLE" "CONTEXT_TRACKING_FORCE" ]
          [ "NO_HZ_FULL_NODEF" "NO_HZ_FULL" "NO_HZ" "NO_HZ_COMMON" "CONTEXT_TRACKING" ]
        ])
        # Tickless idle
        (mapNY [
          [ "HZ_PERIODIC" "NO_HZ_FULL_NODEF" "NO_HZ_FULL" ]
          [ "NO_HZ_IDLE" "NO_HZ" "NO_HZ_COMMON" ]
        ])
      ];
    in
      if builtins.length modes >= tickless
      then builtins.elemAt modes tickless
      else throw "Unsupported tickless value";

    anbox =
      if enableAnbox
      then
        { ANDROID_BINDER_DEVICES = freeform "binder,hwbinder,vndbinder"; }
        // mapNY [
          [ "ION_SYSTEM_HEAP" "ANDROID_BINDER_IPC_SELFTEST" ]
          [ "ASHMEM" "ION" "ION_CMA_HEAP" "ANDROID" "ANDROID_BINDER_IPC" "ANDROID_BINDERFS" ]
        ]
      else {};
    bcachefs =
      if bcachefs
      then
        { BCACHEFS_FS = module; }
        // mapNY [
          [ "BCACHEFS_DEBUG" "BCACHEFS_TESTS" "DEBUG_CLOSURES" ]
          [ "BCACHEFS_QUOTA" "BCACHEFS_POSIX_ACL" ]
        ]
      else {};

    futex2 = { FUTEX2 = boolToKernel futex2; };
    winesync = { WINESYNC = boolToKernelMod winesync; };
    irqThreading = { FORCE_IRQ_THREADING = boolToKernel irqThreading; };
    randomTrustCPU = { RANDOM_TRUST_CPU = boolToKernel randomTrustCPU; };
    smtNice = { SMT_NICE = boolToKernel smtNice; };
    zenify = { ZENIFY = boolToKernel zenify; };
  };
  flattenedConfig = with lib; mapAttrs (_: head) (zipAttrs (attrValues tkgConfig));

  patchNames = [
    "0002-clear-patches"
    "0003-glitched-base"
  ]
  ++ lib.optional miscAdditions "0012-misc-additions"
  ++ lib.optionals (mm == "5.12") [
    "0001-mm-Support-soft-dirty-flag-reset-for-VA-range"
    "0002-mm-Support-soft-dirty-flag-read-with-reset"
  ]
  ++ (
    let
      prjcRevisions = {
        "5.10" = "2";
        "5.12" = "1";
      };
      map = {
        muqss = [
          "0004-${mm}-ck1"
          "0004-glitched-muqss"
        ];
        upds = [
          "0005-v${mm}_undead-pds099o"
          "0005-undead-glitched-pds"
        ];
        pds = if mm == "5.4"
          then [
            "0005-v${mm}_undead-pds099o"
            "0005-glitched-pds"
          ]
          else [
            "0009-prjc_v${mm}-r${prjcRevisions.${mm}}"
            "0005-glitched-pds"
          ];
        bmq = if mm == "5.4"
          then [
            "0009-bmq_v5.4-r2"
            "0009-glitched-bmq"
          ]
          else [
            "0009-prjc_v${mm}-r${prjcRevisions.${mm}}"
            "0009-glitched-bmq"
          ];
        cacule = [
          "0003-cacule-${mm}"
          "0003-glitched-cfs"
        ];
        cfs = ["0003-glitched-cfs"];
      };
    in
    if (builtins.hasAttr scheduler map) && (map.${scheduler} != {})
    then map.${scheduler}
    else []
  )
  ++ lib.optional acsOverride "0006-add-acs-overrides_iommu"
  ++ lib.optionals aggressiveOndemand (
    let map = rec {
      muqss = "0004-glitched-ondemand-muqss";
      upds = "0005-undead-glitched-ondemand-pds";
      pds = if mm == "5.4"
        then "0005-glitched-ondemand-pds"
        else "0009-glitched-ondemand-bmq";
      bmq = if mm != "5.4"
        then "0009-glitched-ondemand-bmq"
        else {};
    }; in
    if (builtins.hasAttr scheduler map) && (map.${scheduler} != {})
    then [map.${scheduler}]
    else []
  )
  ++ lib.optional bcachefs "0008-${mm}-bcachefs"
  ++ lib.optional fsync "0007-v${mm}-fsync"
  ++ lib.optional futex2 "0007-v${mm}-futex2_interface"
  ++ lib.optional winesync "0007-v${mm}-winesync"
  ++ lib.optional zfsFix "0011-ZFS-fix";

  toPatch = name: {
    inherit name;
    patch = "${tkgSource}/linux-tkg-patches/${mm}/${name}.patch";
  };
  tkgPatches = builtins.map (e: toPatch e) (lib.naturalSort patchNames);

  suffix = if builtins.stringLength localVersion != 0 then "-tkg-${localVersion}" else "-tkg";
in buildLinux(args // rec {
  version = "${mmp}-tkg";
  modDirVersion = version + suffix;

  isZen = zenify;

  ignoreConfigErrors = true;
  structuredExtraConfig = with lib.kernel; builtins.mapAttrs (_: value: lib.mkForce value) ({
    LOCALVERSION = freeform suffix;
  } // flattenedConfig
    // extraConfig);

  kernelPatches = #args.kernelPatches
    [{
       name = "patch-${mmp}";
       patch = kernelUrl "patch-${mmp}" "17d38hns5qfbw1pajpa5y38v86r49nqnw7a3pwsay5fapj69z8w4";
    }]
    ++ tkgPatches;
  src = kernelUrl "linux-${mm}.tar" "0rn3z942vjc7bixjw066rm6kcr0x0wzgxqfq1f6xd113pzrgc3bx";
} // (args.argsOverride or {}))
