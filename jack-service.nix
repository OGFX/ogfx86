{ config, pkgs, pcm_device, ...}:
{
  services = {
    jack.jackd = {
      enable = true;
      extraOptions = [ "-S" "-R" "-P 80" "-d" "alsa" "-p" "64" "-n" "3" "-d" pcm_device ];
    };
  };
}

