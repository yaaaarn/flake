{ lib, config, ... }:
let
  inherit (lib) mkEnableOption count id;
  p = config.unravelled.profiles;
in
{
  options.unravelled.profiles = {
    # device profiles
    server.enable = mkEnableOption "Server system";
    laptop.enable = mkEnableOption "Laptop system";
    desktop.enable = mkEnableOption "Desktop system";
    iso.enable = mkEnableOption "ISO system";

    # software profiles
    graphical.enable = mkEnableOption "Graphical system";
    headless.enable = mkEnableOption "Headless system";

    # performance profiles
    perf.low.enable = mkEnableOption "Low-end system";
    perf.mid.enable = mkEnableOption "Mid-range system";
    perf.high.enable = mkEnableOption "High-end system";

    # desktop env profiles
    minimal.enable = mkEnableOption "Minimal system";
    full.enable = mkEnableOption "Full system";
  };

  config = {
    assertions = [
      {
        assertion =
          count id [
            p.server.enable
            p.laptop.enable
            p.desktop.enable
          ] <= 1;
        message = "Only one device profile (server, laptop, desktop) can be enabled.";
      }
      {
        assertion =
          count id [
            p.graphical.enable
            p.headless.enable
          ] <= 1;
        message = "Only one software profile (graphical, headless) can be enabled.";
      }
      {
        assertion =
          count id [
            p.perf.low.enable
            p.perf.mid.enable
            p.perf.high.enable
          ] <= 1;
        message = "Only one performance profile (low, mid, high) can be enabled.";
      }
      {
        assertion =
          count id [
            p.minimal.enable
            p.full.enable
          ] <= 1;
        message = "Only one desktop environment profile (minimal, full) can be enabled.";
      }
    ];
  };
}
