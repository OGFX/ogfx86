{ lib, stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "mod-utilities";
  version = "0.1";

  # src = /home/fps/ogfx/mod-utilities;

  src = pkgs.fetchFromGitHub {
    owner = "ogfx";
    repo = "mod-utilities";
    rev = "prefix";
    # rev = "468d09ae37370139bd79d509b854889a2a567833";
    sha256 = "sha256-bZdLZ51PltkAu4jVNuQKpLiAcNkxUgT4EuHn9/VrQRM";
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
