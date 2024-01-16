{ config, inputs, modules, overlays, pkgs, ... }: {
  networking.hostName = "anemone";
  system.stateVersion = "23.11";
  time.timeZone = "Asia/Phnom_Penh";

  nixpkgs.overlays = [ inputs.neovim-nightly.overlay ];
  age.secrets = {
    passwd.file = ../../secrets/passwd.age;
    #wg_hyacinth.file = ../../secrets/wg_blossom.age;
    #wpa_conf.file = ../../secrets/wpa_conf.age;
  };

  imports = with modules.system; [
    inputs.home-manager.nixosModule
    home-manager

    audio
    base
    ccache
    corectrl
    flatpak
    greetd
    gui
    input
    kernel
    nix
    packages
    printing
    security
    snapper
    #wireguard

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix

    ../../users/rin
  ];

  environment.systemPackages = with pkgs; [ wpa_supplicant_gui ];

  programs.hyprland.enable = true;

  hardware.firmware = let
    fw = "${pkgs.linux-firmware}/lib/firmware/cirrus/";
   in [
      (
    pkgs.runCommandNoCC "cs35l41-10431683" { } ''
      mkdir -p $out/lib/firmware/cirrus
      cd $out/lib/firmware/cirrus
      cp ${fw}/cs35l41-dsp1-spk-cali-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-cali-10431683-spkid0-l0.bin
      cp ${fw}/cs35l41-dsp1-spk-cali-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-cali-10431683-spkid0-r0.bin
      cp ${fw}/cs35l41-dsp1-spk-cali-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-cali-10431683-spkid1-l0.bin
      cp ${fw}/cs35l41-dsp1-spk-cali-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-cali-10431683-spkid1-r0.bin

      cp ${fw}/cs35l41-dsp1-spk-prot-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-prot-10431683-spkid0-l0.bin
      cp ${fw}/cs35l41-dsp1-spk-prot-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-prot-10431683-spkid0-r0.bin
      cp ${fw}/cs35l41-dsp1-spk-prot-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-prot-10431683-spkid1-l0.bin
      cp ${fw}/cs35l41-dsp1-spk-prot-10431e12-spkid0-l0.bin cs35l41-dsp1-spk-prot-10431683-spkid1-r0.bin

      cp ${fw}/cs35l41-dsp1-spk-cali-10431e12.wmfw cs35l41-dsp1-spk-cali-10431683.wmfw
      cp ${fw}/cs35l41-dsp1-spk-prot-10431e12.wmfw cs35l41-dsp1-spk-prot-10431683.wmfw
    ''
  )
  ];

  # For steam fhs-env
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];
}
