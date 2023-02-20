{ config, lib, pkgs, ... }:
{
  systemd.services = {
    jack1 = {
      enable = true;
      description = "jack1 audio server";
      path = [ pkgs.jack1 ];
      serviceConfig = {
        Type = "exec";
        User = "ogfx";
        ExecStart = "${pkgs.bash}/bin/bash -c \"jackd -R -P 70 -d alsa -d hw:iXR -p 64 -n 2 -X\"";
        LimitRTPRIO = 99;
        LimitMEMLOCK = "infinity";
      };
    };
    ogfx-frontend = {
      enable = true;
      description = "The OGFX web frontend";
      wantedBy = [ "jack1.service" ];
      wants = [ "jack1.service" ];
      path = [ pkgs.jack1 pkgs.ogfx-tools pkgs.lilv ];
      serviceConfig = {
        Type = "exec";
        User = "ogfx";
        Environment = "LV2_PATH=${config.environment.variables.LV2_PATH}";
        # ExecStart = "${pkgs.bash}/bin/bash -c \"lv2ls\"";
        # ExecStart = "${pkgs.bash}/bin/bash -c \"jack_wait -w\"";
        ExecStart = "${pkgs.bash}/bin/bash -c \"jack_wait -w && export LV2_PATH=${pkgs.mod-utilities}/lib/lv2:$LV2_PATH; exec ${pkgs.ogfx-ui}/bin/ogfx_frontend_server.py --log-level 5 --lv2-cache ${pkgs.lv2ls_cache}/cache.txt\"";
        LimitRTPRIO = 99;
        LimitMEMLOCK = "infinity";
        KillMode = "mixed";
        KillSignal = "SIGINT";
        TimeoutStopSec = 15;
      };
    };
  };

  users.groups.ogfx = {};

  users.users.ogfx = {
    group = "ogfx";
    isNormalUser = true;
    extraGroups = [ "audio" "ogfx" ];
  };
}
  
