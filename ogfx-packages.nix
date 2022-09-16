{ lib, pkgs, config, ... }:
let
  # make-native = (x: x.override { stdenv = pkgs.withCFlags "-DOGFX_NATIVE -march=native -mtune=native -ffast-math -fno-finite-math-only -funroll-loops -fno-strict-aliasing" pkgs.stdenv;} );
  plugin_packages = with pkgs; [
    guitarix 
    state-variable-filter-lv2 clipping-lv2
    mda_lv2 swh_lv2 aether-lv2
    gxplugins-lv2 gxmatcheq-lv2 airwindows-lv2
    rkrlv2 distrho bshapr bchoppr
    plujain-ramp mod-distortion x42-plugins
    infamousPlugins mooSpace boops
    eq10q talentedhack artyFX fverb
    kapitonov-plugins-pack fomp molot-lite
    zam-plugins lsp-plugins calf gxmatcheq-lv2
    tunefish ams-lv2
  ];
  plugin_packages_lv2_dirs = lib.concatStrings (lib.intersperse ":" (lib.forEach plugin_packages (x: "${x}/lib/lv2")));
in
{
  nixpkgs.overlays = [
    (self: super: {
      mod-host = (pkgs.callPackage ./mod-host.nix {});
      mod-utilities = (pkgs.callPackage ./mod-utilities.nix {});
      ogfx-tools = (pkgs.callPackage ./ogfx-tools.nix {});
      ogfx-ui = (pkgs.python39Packages.callPackage ./ogfx-ui.nix {});
      state-variable-filter-lv2 = (pkgs.callPackage ./state-variable-filter-lv2.nix {});
      clipping-lv2 = (pkgs.callPackage ./clipping-lv2.nix {});
      lv2ls_cache =  (pkgs.runCommand "lv2ls_cache" {} ''
        mkdir $out
	ls $LV2_PATH
	LV2_PATH=${plugin_packages_lv2_dirs} ${self.ogfx-tools}/bin/ogfx_lv2ls > $out/cache.txt
      '');
    })
  ];

  environment.systemPackages = with pkgs; [
    mod-host mod-utilities ogfx-tools
    lilv lv2 plugin-torture lv2ls_cache
  ] ++ plugin_packages;
  
  system.userActivationScripts = {
    update_ogfx_lv2ls_cache = { 
      text = ''
        if [ $(whoami) == ogfx ]; then
          ${pkgs.ogfx-tools}/bin/ogfx_lv2ls > $HOME/.ogfx_lv2ls_cache.txt
        fi
      '';
      deps = [];
    };
  };
}
