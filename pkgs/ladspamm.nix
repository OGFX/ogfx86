{ lib, stdenv, pkgs }:

stdenv.mkDerivation rec {
  pname = "ladspamm1";
  version = "1";

  # src = /home/fps/ogfx/ogfx-tools;

  src = pkgs.fetchFromGitHub {
    owner = "fps";
    repo = "ladspamm";
    rev = "master";
    # rev = "468c09ae37370139bd79d509b854889a2a567833";
    sha256 = "sha256-KJuj9zvozg45/FY9nr5Q7mURXGUnbQVcdsnt2lYDBBs=";
  };

  doCheck = false;

  buildInputs =  with pkgs; [ boost ladspa-sdk valgrind ]; 

  meta = with lib; {
    description = "";
    longDescription = ''
    '';
    homepage = "https://github.com/fps/ladspamm";
    license = licenses.gpl3Plus;
    # maintainers = [ maintainers.eelco ];
    platforms = platforms.all;
  };

  PREFIX = placeholder "out";
}
