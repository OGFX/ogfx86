{ lib, stdenv, pkgs, fetchgit }:

stdenv.mkDerivation rec {
  pname = "fps-plugins-lv2";
  version = "1";

  # src = /home/fps/ogfx/clipping.lv2;

  src = builtins.fetchGit {
    url = https://github.com/fps/fps-plugins.lv2;
    # sha256 = "sha256-+jUDKGHs3IWhcwaBqfoP9D1mkN6/P2GKQTBuzuGOYHo=";
    ref = "master";
    # sha256 = null;
  };

  doCheck = false;

  makeFlags = [ "PREFIX=$(out)" ];

  buildInputs =  with pkgs; [ lv2 fftwFloat libsndfile pkg-config ]; 
  # propagatedBuildInputs = with pkgs; [ lv2 ];

  meta = with lib; {
    description = "";
    longDescription = ''
    '';
    homepage = "https://github.com/ogfx/ogfx-tools";
    license = licenses.gpl3Plus;
    # maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };
}
