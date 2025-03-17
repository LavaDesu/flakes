self: super: let
  llvmPackages = super.llvmPackages_19;
  clangVersion = super.lib.versions.major llvmPackages.libclang.version;
  cc = llvmPackages.stdenv.cc.override {
    # :sob: see https://github.com/NixOS/nixpkgs/issues/142901
    bintools = llvmPackages.bintools;
    extraBuildCommands = ''
      substituteInPlace "$out/nix-support/cc-cflags" --replace " -nostdlibinc" ""
      substituteInPlace "$out/nix-support/add-local-cc-cflags-before.sh" --replace 'echo "Warning: supplying the --target argument to a nix-wrapped compiler may not work correctly - cc-wrapper is currently not designed with multi-target compilers in mind. You may want to use an un-wrapped compiler instead." >&2' ""
      echo " -resource-dir=${llvmPackages.libclang.lib}/lib/clang/${clangVersion}" >> $out/nix-support/cc-cflags
    '';
  };
  stdenv = super.overrideCC llvmPackages.stdenv cc;
  ccacheStdenv = super.ccacheStdenv.override { inherit stdenv; };
in {
  linuxLavaEnv = {
    inherit llvmPackages clangVersion cc stdenv ccacheStdenv;
  };
  rust-bindgen-unwrapped = super.rust-bindgen-unwrapped.override {
    clang = cc;
  };
}
