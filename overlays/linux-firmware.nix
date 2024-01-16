self: super: {
  linux-firmware = super.linux-firmware.overrideAttrs(o: {
    postInstall = ''
    ls -al
      cd cirrus
      ln -s cs35l41-dsp1-spk-cali-10431e12-spkid0-l0.bin.xz cs35l41-dsp1-spk-cali-10431683-spkid0-l0.bin.xz
      ln -s cs35l41-dsp1-spk-cali-10431e12-spkid0-l0.bin.xz cs35l41-dsp1-spk-cali-10431683-spkid0-r0.bin.xz
      ln -s cs35l41-dsp1-spk-cali-10431e12-spkid0-l0.bin.xz cs35l41-dsp1-spk-cali-10431683-spkid1-l0.bin.xz
      ln -s cs35l41-dsp1-spk-cali-10431e12-spkid0-l0.bin.xz cs35l41-dsp1-spk-cali-10431683-spkid1-r0.bin.xz

      ln -s cs35l41-dsp1-spk-prot-10431e12-spkid0-l0.bin.xz cs35l41-dsp1-spk-prot-10431683-spkid0-l0.bin.xz
      ln -s cs35l41-dsp1-spk-prot-10431e12-spkid0-l0.bin.xz cs35l41-dsp1-spk-prot-10431683-spkid0-r0.bin.xz
      ln -s cs35l41-dsp1-spk-prot-10431e12-spkid0-l0.bin.xz cs35l41-dsp1-spk-prot-10431683-spkid1-l0.bin.xz
      ln -s cs35l41-dsp1-spk-prot-10431e12-spkid0-l0.bin.xz cs35l41-dsp1-spk-prot-10431683-spkid1-r0.bin.xz

      ln -s cs35l41-dsp1-spk-cali-10431e12.wmfw.xz cs35l41-dsp1-spk-cali-10431683.wmfw.xz
      ln -s cs35l41-dsp1-spk-prot-10431e12.wmfw.xz cs35l41-dsp1-spk-prot-10431683.wmfw.xz
    '';
  });
}
