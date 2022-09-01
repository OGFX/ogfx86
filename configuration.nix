# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  ogfx-tools = (pkgs.callPackage ./ogfx-tools.nix {});
  ogfx-ui = (pkgs.python36Packages.callPackage ./ogfx-ui.nix { ogfx-tools = ogfx-tools; });
  unstableTarball =
    fetchTarball
      https://github.com/NixOS/nixpkgs/archive/nixos-unstable.tar.gz;
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ./musnix
    ];


  nixpkgs.config = {
    packageOverrides = pkgs: {
      unstable = import unstableTarball {
        config = config.nixpkgs.config;
      };
    };
  };

  musnix.enable = true;
  musnix.kernel.realtime = true;
  musnix.kernel.packages = pkgs.linuxPackages_latest_rt;
  musnix.rtirq.enable = true;
  musnix.rtirq.nameList = "xhci";
  musnix.rtirq.prioLow = 60;

  boot.loader.grub.enable = true;
  boot.loader.grub.version = 2;
  boot.loader.timeout = 1;
  boot.loader.grub.device = "/dev/sda";

  boot.kernelParams = [ "noibrs" "noibpb" "nopti" "nospectre_v2" "nospectre_v1" "l1tf=off" "nospec_store_bypass_disable" "no_stf_barrier" "mds=off" "tsx=on" "tsx_async_abort=off" "mitigations=off" "processor.max_cstate=1" "intel_idle.max_cstate=0" ];
  # boot.kernelParams = [ "noibrs" "noibpb" "nopti" "nospectre_v2" "nospectre_v1" "l1tf=off" "nospec_store_bypass_disable" "no_stf_barrier" "mds=off" "tsx=on" "tsx_async_abort=off" "mitigations=off" ];

  networking.hostName = "ogfx86"; 
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp1s0.useDHCP = true;
  networking.interfaces.enp2s0.useDHCP = true;
  networking.interfaces.enp4s0.useDHCP = true;
  networking.interfaces.enp5s0.useDHCP = true;
  networking.interfaces.wlo1.useDHCP = true;
  networking.firewall.enable = false;
  networking.wireguard.enable = true;

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  environment.systemPackages = with pkgs.unstable; [
    vim
    wget
    htop
    links2
    git
    tmux

    dmenu
    arandr
	
    xfce.xfce4-terminal
    firefox

    schedtool
    usbutils
    psmisc

    # jack2

    jalv
    lv2
    lilv
    ingen
    carla
    
    guitarix
    swh_lv2
    mda_lv2
    ams-lv2
    aether-lv2
    gxplugins-lv2
    gxmatcheq-lv2
    airwindows-lv2
    rkrlv2
    distrho
    bshapr
    bchoppr
    tunefish
    plujain-ramp
    mod-distortion
    x42-plugins
    infamousPlugins
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

    plugin-torture
    ogfx-tools
    ogfx-ui
  ];


  sound.enable = true;
  # hardware.pulseaudio.enable = true;

  services.openssh.enable = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.layout = "us";
  services.xserver.xkbOptions = "eurosign:e";

  services.xserver.displayManager.sddm.enable = true;
  services.xserver.windowManager.i3.enable = true;

  services.avahi.enable = true;
  services.cron.enable = true;

  services.jack.jackd = {
    enable = true;
    extraOptions = [ "-S" "-R" "-P 80" "-d" "alsa" "-p" "64" "-n" "3" "-d" "hw:iXR" ];
  };

  systemd.services = {
    ogfx-frontend = {
      enable = true;
      description = "The OGFX web frontend";
      wantedBy = [ "jack.service" ];
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
    extraGroups = [ "wheel" "audio" "jackaudio" ]; # Enable ‘sudo’ for the user.
  };

  users.users.ogfx = {
    isNormalUser = true;
    extraGroups = [ "audio" "jackaudio" ]; # Enable ‘sudo’ for the user.
  };
  system.stateVersion = "20.03"; # Did you read the comment?

}
