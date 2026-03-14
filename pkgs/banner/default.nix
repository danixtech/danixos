{ pkgs, buildId ? "dev" }:

pkgs.stdenv.mkDerivation {
  pname = "danix-banner";
  version = "0.1";

  src = ../../modules;

  installPhase = ''
    mkdir -p $out/bin
    cp banner.sh $out/bin/danix-banner
    cp system-summary.sh $out/bin/danix-system-summary
    chmod +x $out/bin/*
    sed -i "0,/__DANIX_VERSION__/s|__DANIX_VERSION__|${buildId}|" \
      "$out/bin/danix-banner"
  '';
}
