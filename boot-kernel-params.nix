{ config, pkgs, ...}:
{
  boot.kernelParams = [
    "processor.max_cstate=1" "intel_idle.max_cstate=0"
  ];
}
