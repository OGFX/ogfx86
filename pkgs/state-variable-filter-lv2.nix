{ lib, stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec {
  pname = "state-variable-filter-lv2";
  version = "0.1";

  # src = /home/fps/ogfx/state-variable-filter.lv2;

  src = pkgs.fetchgit {
    url = https://github.com/fps/state-variable-filter.lv2;
    fetchSubmodules = true;
    # rev = "468c09ae37370139bd79d509b854889a2a567833";
    sha256 = "sha256-QcssMng3IEcx+io2i4PhWoUi6zVKe5oAht/4VOBofb8=";
  };

  doCheck = true;

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs =  with pkgs; [ lv2 ]; 
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
