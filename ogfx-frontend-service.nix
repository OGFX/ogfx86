{ config, lib, pkgs, ogfx-ui, ... }:
{
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
}
  
