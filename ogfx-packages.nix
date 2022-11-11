{ lib, pkgs, config, ... }:
let
  # make-native = (x: x.override { stdenv = pkgs.withCFlags "-DOGFX_NATIVE -march=native -mtune=native -ffast-math -fno-finite-math-only -funroll-loops -fno-strict-aliasing" pkgs.stdenv;} );
  plugin_packages = with pkgs; [
    rt-tests
  	# mod-pitchshifter
    guitarix mod-utilities  vintageac30-lv2
    state-variable-filter-lv2 clipping-lv2
    mda_lv2 swh_lv2 aether-lv2 xplugs-lv2
    gxplugins-lv2 gxmatcheq-lv2 airwindows-lv2
    rkrlv2 distrho bshapr bchoppr
    plujain-ramp mod-distortion x42-plugins
    infamousPlugins mooSpace boops
    eq10q talentedhack artyFX fverb
    kapitonov-plugins-pack fomp molot-lite
    zam-plugins lsp-plugins calf gxmatcheq-lv2
    tunefish ams-lv2 relative_dynamics-lv2
  ];
  plugin_packages_lv2_dirs = lib.concatStrings (lib.intersperse ":" (lib.forEach plugin_packages (x: "${x}/lib/lv2")));
in
{
  nixpkgs.overlays = [
    (self: super: {
      mod-host = (pkgs.callPackage ./mod-host.nix {});
      mod-utilities = (pkgs.callPackage ./mod-utilities.nix {});
      mod-pitchshifter = (pkgs.callPackage ./mod-pitchshifter.nix {});
      ogfx-tools = (pkgs.callPackage ./ogfx-tools.nix {});
      ogfx-ui = (pkgs.python39Packages.callPackage ./ogfx-ui.nix {});
      state-variable-filter-lv2 = (pkgs.callPackage ./state-variable-filter-lv2.nix {});
      clipping-lv2 = (pkgs.callPackage ./clipping-lv2.nix {});
      relative_dynamics-lv2 = (pkgs.callPackage ./relative_dynamics-lv2.nix {});
      xplugs-lv2 = (pkgs.callPackage ./xplugs.nix {});
      vintageac30-lv2 = (pkgs.callPackage ./vintageac30.nix {});
      lv2ls_cache =  (pkgs.runCommand "lv2ls_cache" {} ''
        mkdir $out
      	ls $LV2_PATH
       	LV2_PATH=${plugin_packages_lv2_dirs} ${self.ogfx-tools}/bin/ogfx_lv2ls > $out/cache.txt
      '');
    })
  ];

  environment.systemPackages = with pkgs; [
    mod-host ogfx-tools
    lilv lv2 plugin-torture lv2ls_cache
  ] ++ plugin_packages;

  services.journald.extraConfig = ''
    SystemMaxFileSize=20M
    Storage=volatile
  '';

  environment.variables = {
    LV2_PATH = plugin_packages_lv2_dirs;
  };

  systemd.network.wait-online.timeout = 0;
}
