{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./musnix
      ./boot-kernel-params.nix
      ./ogfx-packages.nix
      ./ogfx-frontend-service.nix {}
      # ./ogfx-frontend-service.nix { _module.args = { ogfx-ui = pkgs.ogfx-ui; ogfx-tools = pkgs.ogfx-tools; mod-utilities = pkgs.mod-utilities; }; }
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
    [
      jalv lv2 lilv plugin-torture
      state-variable-filter-lv2 clipping-lv2

      mda_lv2 swh_lv2 aether-lv2
      gxplugins-lv2 gxmatcheq-lv2 airwindows-lv2
      rkrlv2 distrho bshapr bchoppr
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
  };

  users.users.fps = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "jackaudio" ]; 
  };

  system.stateVersion = "20.03"; 
}
