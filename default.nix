{ config, pkgs, ... }:

{ 
  nixpkgs.config.allowUnfree = true;

  imports =
  [
    ./boot-kernel-params.nix
    ./ogfx-packages.nix
    ./ogfx-frontend-service.nix
  ];

  nixpkgs.overlays = [
  ];
}

