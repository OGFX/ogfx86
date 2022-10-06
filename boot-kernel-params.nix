{ config, pkgs, ...}:
{
  boot.kernelParams = [
    "noibrs" "noibpb" "nopti" "nospectre_v2" "nospectre_v1" "l1tf=off"
    "nospec_store_bypass_disable" "no_stf_barrier" "mds=off" "tsx=on"
    "tsx_async_abort=off" "mitigations=off" "processor.max_cstate=1"
    "intel_idle.max_cstate=0"
  ] ++ [
    "acpi=off"
  ];
}
