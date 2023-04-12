{ lib, stdenv, pkgs, ... }:

stdenv.mkDerivation rec {
  pname = "horsting";
  version = "0.1";

  # If you have your sources locally, you can specify a path
  # src = /home/fps/src/projects/linux-audio/horst;
  src = builtins.fetchGit {
    url = "https://github.com/fps/horst";
    ref = "master";
  };

  # Pull source from a Git server. Optionally select a specific `ref` (e.g. branch),
  # or `rev` revision hash.
  # src = builtins.fetchGit {
  #   url = "git://github.com/stigok/ruterstop.git";
  #   ref = "master";
  #   #rev = "a9a4cd60e609ed3471b4b8fac8958d009053260d";
  # };

  # Specify runtime dependencies for the package
  nativeBuildInputs = [ pkgs.python3Packages.pybind11 pkgs.pkg-config pkgs.lilv pkgs.lv2 pkgs.jack2 ];

  PREFIX = "$(out)";
 
  makeFlags = "-j";

  doCheck = false;

  # Meta information for the package
  meta = {
    description = ''
    '';
  };
}


