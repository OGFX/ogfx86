{ lib, stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec {
  pname = "neural-amp-modeler-lv2";
  version = "0.1";

  # src = /home/fps/ogfx/mod-utilities;

  src = fetchgit {
    url = "https://github.com/mikeoliphant/neural-amp-modeler-lv2.git";
    # rev = "main";
    fetchSubmodules = true;
    # rev = "468d09ae37370139bd79d509b854889a2a567833";
    sha256 = "sha256-dzQ3do3etYJfeQvRoxtQmedvIzgog4fp6xa+MEs7GzM=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = false;

  buildInputs =  with pkgs; [ pkg-config lv2 cmake ]; 
  # propagatedBuildInputs = with pkgs; [ lilv lv2 serd sord sratom];

  installPhase = ''
    mkdir -p "$out"/lib/lv2
    cp -r neural_amp_modeler.lv2 "$out"/lib/lv2
  '';

  meta = with lib; {
    description = "";
    longDescription = ''
    '';
    homepage = "https://github.com/ogfx/ogfx-tools";
    license = licenses.gpl3Plus;
    # maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };

  prefix = placeholder "out";
}
