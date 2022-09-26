{ lib, stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec {
  pname = "clipping-lv2";
  version = "0.1";

  # src = /home/fps/ogfx/clipping.lv2;

  src = pkgs.fetchgit {
    url = https://github.com/fps/clipping.lv2;
    sha256 = "sha256-Ww/r4Q0O5EeAiTQ74sk3vZWX7yYLi6zyPCPA64JBKVs=";
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
