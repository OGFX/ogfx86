{ lib, pkgs, config, ... }:
{
  nixpkgs.overlays = [
    (self: super:
    {
      mod-host = (pkgs.callPackage ./mod-host.nix {});
      mod-utilities = (pkgs.callPackage ./mod-utilities.nix {});
      ogfx-tools = (pkgs.callPackage ./ogfx-tools.nix {});
      ogfx-ui = (pkgs.python39Packages.callPackage ./ogfx-ui.nix {});
      state-variable-filter-lv2 = (pkgs.callPackage ./state-variable-filter-lv2.nix {});
      clipping-lv2 = (pkgs.callPackage ./clipping-lv2.nix {});
    }
  )];

  environment.systemPackages = with pkgs; [
      lilv lv2 plugin-torture

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
}
