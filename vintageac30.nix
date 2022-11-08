{ lib, stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "vintageac30-lv2";
  version = "0.1";

  src = pkgs.fetchFromGitHub {
    owner = "brummer10";
    repo = "VintageAC30.lv2";
    fetchSubmodules = true;
    rev = "ecec14b21ee698b20686d7bb542dfa1207aa6bbe";
    # rev = "468d09ae37370139bd79d509b854889a2a567833";
    sha256 = "sha256-44RXaDUZb+ibOBpDeX6ixQh9SeAxlRQjHji4FtZWkD0=";
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
