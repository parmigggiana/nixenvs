{pkgs ? import <nixpkgs> {}, ...}: let
  envname = "pio-arduino-fhs";
  # as a function to make sure the same pkgs is used as in targetPkgs
  mypython = pks: pks.python3.withPackages (ps: with ps; [platformio pylibftdi pyusb black isort rich]);
  # "proxy" env, is this useful/necessary???
  # myEnv = pkgs.buildEnv {
  #   name = envname;
  #   paths = [ pkgs.zsh ];
  # };
in
  (pkgs.buildFHSUserEnv {
    name = envname;
    targetPkgs = pkgs: (with pkgs; [
      arduino-cli
      avrdude
      libftdi
      # libusb
      libftdi1
      libusb1
      platformio-core
      (mypython pkgs)
      fish
    ]);
    runScript = ''
      ${pkgs.fish}/bin/fish
    '';
  })
  .env
