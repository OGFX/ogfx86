{ config, pkgs, ... }:

let
  ogfx-tools = (pkgs.callPackage ./ogfx-tools.nix {});
  ogfx-ui = (pkgs.python39Packages.callPackage ./ogfx-ui.nix { ogfx-tools = ogfx-tools; });
  state-variable-filter-lv2 = (pkgs.callPackage ./state-variable-filter-lv2.nix {});
  clipping-lv2 = (pkgs.callPackage ./clipping-lv2.nix {});
  # optimized_pkgs = import <nixpkgs> {
  #   localSystem = {
  #     gcc.arch = "westmere";
  #     gcc.tune = "westmere";
  #     system = "x86_64-linux";
  #   };
  # };
  optimized_pkgs = pkgs;
in
{
  imports =
    [
      ./hardware-configuration.nix
      ./musnix
    ];

  nix.settings.system-features = [ "big-parallel" "nixos-test" "kvm" "benchmark" "gccarch-westmere" ];

  nixpkgs.localSystem = {
    gcc.arch = "westmere";
    gcc.tune = "westmere";
    system = "x86_64-linux";
  };

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

  boot.kernelParams = [ 
    "noibrs" "noibpb" "nopti" "nospectre_v2" "nospectre_v1" "l1tf=off" 
    "nospec_store_bypass_disable" "no_stf_barrier" "mds=off" "tsx=on" 
    "tsx_async_abort=off" "mitigations=off" "processor.max_cstate=1" 
    "intel_idle.max_cstate=0" 
  ];

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
    ]) 
    ++ 
    (with optimized_pkgs; [
      jalv lv2 lilv ingen carla guitarix plugin-torture
    ] 
    ++ 
    [
      ogfx-ui state-variable-filter-lv2 clipping-lv2
    ] 
    ++ 
    [
      swh_lv2 mda_lv2 ams-lv2 aether-lv2
      gxplugins-lv2 gxmatcheq-lv2 airwindows-lv2
      rkrlv2 distrho bshapr bchoppr tunefish
      plujain-ramp mod-distortion x42-plugins
      infamousPlugins mooSpace boops
      eq10q talentedhack artyFX fverb
      kapitonov-plugins-pack fomp molot-lite
      zam-plugins lsp-plugins calf gxmatcheq-lv2
    ]);
  
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

    jack.jackd = {
      enable = true;
      extraOptions = [ "-S" "-R" "-P 80" "-d" "alsa" "-p" "64" "-n" "3" "-d" "hw:iXR" ];
    };
  };

  systemd.services = {
    ogfx-frontend = {
      enable = true;
      description = "The OGFX web frontend";
      wantedBy = [ "jack.service" ];
      wants = [ "jack.service" ];
      serviceConfig = {
        Type = "exec";
        User = "ogfx";
        ExecStart = "${pkgs.bash}/bin/bash -l -c \"${pkgs.jack2}/bin/jack_wait -w; exec ${ogfx-ui}/bin/ogfx_frontend_server.py\"";
        LimitRTPRIO = 99;
        LimitMEMLOCK = "infinity";
        KillMode = "mixed";
        KillSignal = "SIGINT";
        TimeoutStopSec = 60;
      };
    };
  };

  users.users.fps = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "jackaudio" ]; 
  };

  users.users.ogfx = {
    isNormalUser = true;
    extraGroups = [ "audio" "jackaudio" ]; 
  };

  system.stateVersion = "20.03"; 
}
