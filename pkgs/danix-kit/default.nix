{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "danix-kit";

  src = ../../danix-kit;

  installPhase = ''
    mkdir -p $out/bin
    cp -r $src/* $out/bin/
    chmod +x $out/bin/*
  '';
}
