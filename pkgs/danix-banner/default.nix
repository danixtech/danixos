{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "danix-banner";

  src = ../../modules;

  installPhase = ''
    mkdir -p $out/bin
    cp banner.sh $out/bin/danix-banner
    cp system-summary.sh $out/bin/danix-system-summary
    chmod +x $out/bin/*
  '';
}
