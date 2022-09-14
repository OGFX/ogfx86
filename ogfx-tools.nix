{ lib, stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "ogfx-tools";
  version = "0.1";

  # src = /home/fps/ogfx/ogfx-tools;

  src = pkgs.fetchFromGitHub {
    owner = "ogfx";
    repo = "ogfx-tools";
    rev = "master";
    # rev = "468c09ae37370139bd79d509b854889a2a567833";
    sha256 = "sha256-v9/qfoCUNfj3oOYWgCDBW4Nm+2Jwa+8Lhr2H0VqmUvw=";
  };

  doCheck = true;

  buildInputs =  with pkgs; [ jack2 boost pkg-config lilv lv2 serd sord sratom ]; 
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
