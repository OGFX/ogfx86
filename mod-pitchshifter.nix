{ lib, stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "mod-pitchshifter";
  version = "0.1";

  # src = /home/fps/ogfx/mod-pitchshifter;

  src = pkgs.fetchFromGitHub {
    owner = "moddevices";
    repo = "mod-pitchshifter";
    rev = "master";
    # rev = "468d09ae37370139bd79d509b854889a2a567833";
    sha256 = "0pwf8mca0cxcl5dkpl2ar10aq1fhbb59hazl9hqpq5w5srffr8l1";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  buildInputs =  with pkgs; [ pkg-config lv2 fftwFloat armadillo ]; 
  # propagatedBuildInputs = with pkgs; [ lilv lv2 serd sord sratom];

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
