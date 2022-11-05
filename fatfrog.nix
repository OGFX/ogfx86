{ lib, stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "fatfrog";
  version = "0.1";

  # src = /home/fps/ogfx/mod-pitchshifter;

  src = pkgs.fetchFromGitHub {
    owner = "brummer10";
    repo = "FatFrog";
    rev = "3361dd312f0933c69397f156a62388ed2c411fe6";
    # rev = "468d09ae37370139bd79d509b854889a2a567833";
    sha256 = "sha256-ybHfRYlARsceAzx9N7uRUobKs0RexrMsqllyGc4qc+Q=";
  };

  doCheck = true;

  buildInputs =  with pkgs; [ pkg-config lv2 ]; 
  # propagatedBuildInputs = with pkgs; [ lilv lv2 serd sord sratom];

  makeFlags = [ "INSTALL_DIR=$(out)/lib/lv2" ];
  # patchPhase = ''
  #   substituteInPlace FatFrog/Makefile --replace /usr/lib $out
  # '';

  meta = with lib; {
    description = "";
    longDescription = ''
    '';
    license = licenses.gpl3Plus;
    # maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };

  prefix = placeholder "out";
}
