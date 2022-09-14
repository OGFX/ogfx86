{ lib, pkgs, config, ... }:
{
  nixpkgs.overlays = [
    (self: super:
    {
      mod-host = (pkgs.callPackage ./mod-host.nix {});
      mod-utilities = (pkgs.callPackage ./mod-utilities.nix {});
      ogfx-tools = (pkgs.callPackage ./ogfx-tools.nix {});
      ogfx-ui = (pkgs.python39Packages.callPackage ./ogfx-ui.nix { ogfx-tools = self.ogfx-tools; mod-host = self.mod-host; mod-utilities = self.mod-utilities; });
      state-variable-filter-lv2 = (pkgs.callPackage ./state-variable-filter-lv2.nix {});
      clipping-lv2 = (pkgs.callPackage ./clipping-lv2.nix {});
    }
  )];
}
