{ lib, pkgs, config, ... }:
let
  plugin_packages = with pkgs; [
    rt-tests
    # guitarix 
    mod-utilities  
    vintageac30-lv2
    state-variable-filter-lv2 
    clipping-lv2
    mda_lv2 
    swh_lv2 
    aether-lv2 
    gxplugins-lv2 
    gxmatcheq-lv2 
    airwindows-lv2
    rkrlv2 distrho 
    bshapr 
    bchoppr
    plujain-ramp 
    mod-distortion 
    x42-plugins
    # infamousPlugins 
    mooSpace 
    boops
    eq10q 
    talentedhack 
    artyFX 
    fverb
    kapitonov-plugins-pack 
    fomp 
    molot-lite
    zam-plugins 
    lsp-plugins 
    calf 
    gxmatcheq-lv2
    ams-lv2 
    relative_dynamics-lv2
    bollie-delay
    guitarix

    # mod-pitchshifter # takes ages to build
    # xplugs-lv2 # build fails
    # tunefish # build fails
  ];
  plugin_packages_lv2_dirs = lib.concatStrings (lib.intersperse ":" (lib.forEach plugin_packages (x: "${x}/lib/lv2")));
in
{
  nixpkgs.overlays = [
    (self: super: {
      mod-host = (pkgs.callPackage ./pkgs/mod-host.nix {});
      mod-utilities = (pkgs.callPackage ./pkgs/mod-utilities.nix {});
      bollie-delay = (pkgs.callPackage ./pkgs/bolliedelay.nix {});
      mod-pitchshifter = (pkgs.callPackage ./pkgs/mod-pitchshifter.nix {});
      ogfx-tools = (pkgs.callPackage ./pkgs/ogfx-tools.nix {});
      ogfx-ui = (pkgs.python39Packages.callPackage ./pkgs/ogfx-ui.nix {});
      state-variable-filter-lv2 = (pkgs.callPackage ./pkgs/state-variable-filter-lv2.nix {});
      clipping-lv2 = (pkgs.callPackage ./pkgs/clipping-lv2.nix {});
      relative_dynamics-lv2 = (pkgs.callPackage ./pkgs/relative_dynamics-lv2.nix {});
      xplugs-lv2 = (pkgs.callPackage ./pkgs/xplugs.nix {});
      vintageac30-lv2 = (pkgs.callPackage ./pkgs/vintageac30.nix {});
      lv2ls_cache =  (pkgs.runCommand "lv2ls_cache" {} ''
        echo out: $out
        mkdir -p $out/share/ogfx_lv2ls_cache
      	ls $LV2_PATH
       	LV2_PATH=${plugin_packages_lv2_dirs} ${self.ogfx-tools}/bin/ogfx_lv2ls > $out/share/ogfx_lv2ls_cache/cache.txt
      '');
      ladspamm = (pkgs.callPackage ./pkgs/ladspamm.nix {});
    })
  ];

  environment.systemPackages = with pkgs; [
    mod-host ogfx-tools
    lilv lv2 plugin-torture lv2ls_cache 
    ladspamm
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
