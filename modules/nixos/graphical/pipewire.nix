{ config, lib, ... }:
let
  inherit (lib) mkIf;
in
{
  config = mkIf config.unravelled.profiles.graphical.enable {
    services.pipewire = {
      enable = true;
      alsa = {
        enable = true;
        support32Bit = true;
      };
      pulse.enable = true;
      jack.enable = true;

      extraConfig = {
        pipewire."99-lowlatency" = {
          "context.properties"."default.clock.min-quantum" = 64;
          "context.modules" = [
            {
              name = "libpipewire-module-rt";
              flags = [
                "ifexists"
                "nofail"
              ];
              args = {
                "nice.level" = -15;
                "rt.prio" = 88;
                "rt.time.soft" = 200000;
                "rt.time.hard" = 200000;
              };
            }
          ];
        };
        pipewire-pulse."99-lowlatency"."pulse.properties" = {
          "server.address" = [ "unix:native" ];
          "pulse.min.req" = "64/48000";
          "pulse.min.quantum" = "64/48000";
          "pulse.min.frag" = "64/48000";
        };
        client."99-lowlatency"."stream.properties" = {
          "node.latency" = "64/48000";
          "resample.quality" = 1;
        };
      };

      wireplumber = {
        enable = true;
        extraConfig = {
          "99-alsa-lowlatency"."monitor.alsa.rules" = [
            {
              matches = [ { "node.name" = "~alsa_output.*"; } ];
              actions.update-props = {
                "audio.format" = "S32LE";
                "audio.rate" = 48000;
              };
            }
          ];
        };
      };
    };
  };
}
