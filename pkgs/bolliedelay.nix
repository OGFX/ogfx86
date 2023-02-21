{ lib, stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "bollie-delay";
  version = "0.1";

  # src = /home/fps/ogfx/mod-utilities;

  src = pkgs.fetchFromGitHub {
    owner = "MrBollie";
    repo = "bolliedelay.lv2";
    rev = "e00d63e5011ac209de3a70bd9a83c7cbb896383a";
    # rev = "468d09ae37370139bd79d509b854889a2a567833";
    sha256 = "sha256-3/e4gAqKLbfQwHft0ztFvq/yXm+XDzvyOOYrbvmKyAs=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  buildInputs =  with pkgs; [ pkg-config lv2 ]; 
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
