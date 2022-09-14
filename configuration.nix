{ config, pkgs, ... }:

let
  # make-native = (x: x.override { stdenv = pkgs.withCFlags "-march=native -mtune=native -ffast-math -fno-finite-math-only -funroll-loops -fno-strict-aliasing" pkgs.stdenv;} );
  make-native = (x: x);
  mod-host = (pkgs.callPackage ./mod-host.nix {});
  mod-utilities = (pkgs.callPackage ./mod-utilities.nix {});
  ogfx-tools = (pkgs.callPackage ./ogfx-tools.nix {});
  ogfx-ui = (pkgs.python39Packages.callPackage ./ogfx-ui.nix { ogfx-tools = ogfx-tools; mod-host = mod-host; mod-utilities = mod-utilities; });
  state-variable-filter-lv2 = (pkgs.callPackage ./state-variable-filter-lv2.nix {});
  clipping-lv2 = (pkgs.callPackage ./clipping-lv2.nix {});
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./musnix
      ./boot-kernel-params.nix
      ./ogfx-frontend-service.nix { _module.args = { ogfx-ui = ogfx-ui; }; }
      ./jack-service.nix { _module.args = { pcm_device = "hw:iXR"; period_size = "64"; number_of_periods = "3"; }; }
    ];

  musnix = {
    enable = true;
    kernel.optimize = true;
    kernel.realtime = true;
    # kernel.packages = pkgs.linuxPackages_latest_rt;
    rtirq.enable = true;
    rtirq.nameList = "xhci";
    rtirq.prioLow = 60;
  };

  boot.loader = {
    grub.enable = true;
    grub.version = 2;
    grub.device = "/dev/sda";
    timeout = 1;
  };

  boot.kernelModules = [ "coretemp" ];

  networking.hostName = "ogfx86"; 
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  networking = {
    useDHCP = false;
    interfaces = { 
      enp1s0.useDHCP = true;
      enp2s0.useDHCP = true;
      enp4s0.useDHCP = true;
      enp5s0.useDHCP = true;
      wlo1.useDHCP = true;
    };
    firewall.enable = false;
    wireguard.enable = true;
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Berlin";

  environment.systemPackages = 
    (with pkgs; [
      vim wget htop links2 git tmux
      schedtool usbutils psmisc
      lm_sensors
  
      dmenu arandr xfce.xfce4-terminal firefox
      man-pages man-pages-posix
    ] 
    ++
    [  
      tunefish ingen carla guitarix 

      ams-lv2 
    ] 
    ++ 
    (lib.lists.forEach [
      jalv mod-host lv2 lilv plugin-torture
      ogfx-ui state-variable-filter-lv2 clipping-lv2

      mda_lv2 swh_lv2 aether-lv2
      gxplugins-lv2 gxmatcheq-lv2 airwindows-lv2
      rkrlv2 distrho bshapr bchoppr
      plujain-ramp mod-distortion x42-plugins
      infamousPlugins mooSpace boops
      eq10q talentedhack artyFX fverb
      kapitonov-plugins-pack fomp molot-lite
      zam-plugins lsp-plugins calf gxmatcheq-lv2
      mod-utilities
    ] make-native));
  
  sound.enable = true;

  services = {
    openssh.enable = true;

    xserver = {
      enable = true;
      layout = "us";
      xkbOptions = "eurosign:e";

      displayManager.sddm.enable = true;
      windowManager.i3.enable = true;
    };

    avahi.enable = true;
    cron.enable = true;

  #   jack.jackd = {
  #     enable = true;
  #     extraOptions = [ "-S" "-R" "-P 80" "-d" "alsa" "-p" "64" "-n" "3" "-d" "hw:iXR" ];
  #     package = (make-native pkgs.jack2);
  #   };
  };

  users.users.fps = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "jackaudio" ]; 
  };

  # users.users.ogfx = {
  #   isNormalUser = true;
  #   extraGroups = [ "audio" "jackaudio" ]; 
  # };

  system.stateVersion = "20.03"; 
}
