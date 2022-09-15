{ lib, stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "mod-host";
  version = "0.1";

  # src = /home/fps/ogfx/mod-host;

  src = pkgs.fetchFromGitHub {
    owner = "ogfx";
    repo = "mod-host";
    rev = "prefix";
    # rev = "468c09ae37370139bd79d509b854889a2a567833";
    sha256 = "sha256-y4qdGK0+tzoGr2h0jURgpck2jR/KaX1t5HDvE7exc+c=";
  };

  makeFlags = [ "PREFIX=$(out)" ];

  doCheck = true;

  buildInputs =  with pkgs; [ pkg-config lv2 jack2 lilv serd sord sratom python3 readline ]; 
  # propagatedBuildInputs = with pkgs; [ lilv lv2 serd sord sratom];

  checkPhase = "";

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
