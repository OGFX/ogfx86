{ lib, stdenv, buildPythonPackage, bottle, pkgs, ... }:

buildPythonPackage rec {
  pname = "ogfx-ui";
  version = "0.1";

  # If you have your sources locally, you can specify a path
  # src = /home/fps/ogfx/ogfx-ui;
  src = builtins.fetchGit {
    url = "https://github.com/OGFX/ogfx-ui";
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
  propagatedBuildInputs = with pkgs; [ bottle ogfx-tools mod-host ];

  doCheck = false;

  # Meta information for the package
  meta = {
    description = ''
    '';
  };
}


