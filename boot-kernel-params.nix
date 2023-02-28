{ config, pkgs, ...}:
{
  boot.kernelParams = [
    "processor.max_cstate=0" "intel_idle.max_cstate=0" "idle=poll"
  ];
}
