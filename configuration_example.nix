{ config, pkgs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
      ./musnix

      # make-linux-fast-again.com:
      ./ogfx86/boot-kernel-params.nix

      # add all required packages:
      ./ogfx86/ogfx-packages.nix

      # and finally add the ogfx service:
      ./ogfx86/ogfx-frontend-service.nix {}
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

      ingen carla guitarix 
      jalv
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

  services = {
    jack.jackd = {
      enable = true;
      extraOptions = [ "-S" "-R" "-P 80" "-d" "alsa" "-p" "64" "-n" "3" "-d" "hw:iXR" ];
    };
  };

  users.users.fps = {
    isNormalUser = true;
    extraGroups = [ "wheel" "audio" "jackaudio" ]; 
  };

  system.stateVersion = "20.03"; 
}
