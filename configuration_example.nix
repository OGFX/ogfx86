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

  # you want to use a realtime kernel. 
  # musnix is helpful here:
  musnix = {
    enable = true;
    kernel.optimize = true;
    kernel.realtime = true;
    # kernel.packages = pkgs.linuxPackages_latest_rt;
 
    # do some irq tuning. adapt this to your particular system
    rtirq.enable = true;
    rtirq.nameList = "xhci";
    rtirq.prioLow = 60;
  };

  # setup jack as a system service. this is required
  # for ogfx. adapt the parameters to your need:
  services = {
    jack.jackd = {
      enable = true;
      extraOptions = [ "-S" "-R" "-P 80" "-d" "alsa" "-p" "64" "-n" "3" "-d" "hw:iXR" ];
    };
  };


  # the rest of this file is just a vanilla
  # nixos configuration. all ogfx-related changes 
  # are above this point..

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
    networkmanager.enable = true;
    interfaces.wlo1.ipv4.addresses = [ { address = "192.168.150.1"; prefixLength = 24; } ];
    useDHCP = false;
  #   interfaces = { 
  #     enp1s0.useDHCP = true;
  #     enp2s0.useDHCP = true;
  #     enp4s0.useDHCP = true;
  #     enp5s0.useDHCP = true;
  #     wlo1.useDHCP = true;
  #   };
    firewall.enable = false;
    wireguard.enable = true;

    localCommands = ''
      echo 1 > /proc/sys/net/ipv4/ip_forward
      ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -o enp1s0 -j MASQUERADE 
      ${pkgs.iptables}/bin/iptables -A FORWARD -i enp1s0 -o wlo1 -m state --state RELATED,ESTABLISHED -j ACCEPT 
      ${pkgs.iptables}/bin/iptables -A FORWARD -i wlo1 -o enp1s0 -j ACCEPT
    '';

    networkmanager.extraConfig = ''
      [keyfile]
      unmanaged-devices=interface-name:wlo1
    '';
  };

  i18n.defaultLocale = "en_US.UTF-8";
  time.timeZone = "Europe/Berlin";

  environment.systemPackages = 
    (with pkgs; [
      vim wget htop links2 git tmux
      schedtool usbutils psmisc
      lm_sensors
      wirelesstools
  
      dmenu arandr xfce.xfce4-terminal firefox
      man-pages man-pages-posix

      ingen carla guitarix 
      jalv
    ]);
  
  sound.enable = true;

  environment.etc."dnsmasq-addn-hosts.txt".text =
    ''
        192.168.150.1 ogfx86
    '';

  services = {
    dnsmasq = {
      enable = true;
      extraConfig = ''
        addn-hosts=/etc/dnsmasq-addn-hosts.txt
        # Bind to only one interface
        bind-interfaces
        # Choose interface for binding
        interface=wlo1
        # Specify range of IP addresses for DHCP leasses
        dhcp-range=192.168.150.100,192.168.150.200
      ''; 
    };

    hostapd = {
      enable = true;
      interface = "wlo1";
      ssid = "ogfx86";
      wpaPassphrase = "omg it's fx";
    };
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
