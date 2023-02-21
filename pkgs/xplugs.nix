{ lib, stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "xplugs-lv2";
  version = "0.1";

  src = pkgs.fetchFromGitHub {
    owner = "brummer10";
    repo = "XPlugs.lv2";
    fetchSubmodules = true;
    rev = "11a5624f7e799911e3c53ba809717a8423bc461f";
    # rev = "468d09ae37370139bd79d509b854889a2a567833";
    sha256 = "sha256-aOtX8s9b3w0cywFy8DQn6AIvSvMsOwVMTHjARonZqgw=";
  };

  doCheck = true;

  buildInputs =  with pkgs; [ vim pkg-config lv2 cairo fluidsynth lilv libsndfile glib pcre2 xorg.libXdmcp ]; 
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
