{ lib, stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "melmatcheq-lv2";
  version = "0.1";

  src = pkgs.fetchFromGitHub {
    owner = "brummer10";
    repo = "MelMatchEq.lv2";
    fetchSubmodules = true;
    rev = "36e9ca3e5d5b0a045e0c465afc45d4d1ca5f8eb5";
    sha256 = "sha256-xqQ8zDsPU/oH01HxwtuamjVOfLvCqlsird7Bns5OVtQ=";
  };

  doCheck = true;

  buildInputs =  with pkgs; [ vim pkg-config lv2 cairo  ]; 
  # buildInputs =  with pkgs; [ vim pkg-config lv2 cairo fluidsynth lilv libsndfile glib pcre2 xorg.libXdmcp ]; 
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
