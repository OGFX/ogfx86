{ config, pkgs, pcm_device, period_size, number_of_periods, ...}:
{
  services = {
    jack.jackd = {
      enable = true;
      extraOptions = [ "-S" "-R" "-P 80" "-d" "alsa" "-p" period_size "-n" number_of_periods "-d" pcm_device ];
    };
  };
}

