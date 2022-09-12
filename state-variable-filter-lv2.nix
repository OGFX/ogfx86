{ lib, stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "state-variable-filter-lv2";
  version = "0.1";

  src = /home/fps/ogfx/state-variable-filter.lv2;

  # src = pkgs.fetchFromGitHub {
  #   owner = "ogfx";
  #   repo = "ogfx-tools";
  #   rev = "master";
  #   # rev = "468c09ae37370139bd79d509b854889a2a567833";
  #   sha256 = "09vxmrgx09ppbkkjalma65gz16giy8pmb0hl9sgf1qkmxpxfg0lw";
  # };

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