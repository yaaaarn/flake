{
  lib,
  pkgs,
  config,
  ...
}:
let
  inherit (lib) mkDefault mkIf;
in
{
  system.stateVersion = "26.11";

  environment.systemPackages = with pkgs; [
    toybox
    inetutils
    pciutils
    lm_sensors
    brightnessctl
    bluetui
    wiremix
    ripgrep
    git
  ];

  time.timeZone = mkDefault "Europe/Paris";
  # home manager
  environment.pathsToLink = [
    "/share/applications"
    "/share/xdg-desktop-portal"
  ];

  programs = {
    zsh.enable = true;
    dconf.enable = true;

    gnupg = {
      agent = {
        enable = true;
      };
    };

    localsend = {
      enable = config.unravelled.profiles.graphical.enable;
      openFirewall = true;
    };

    nix-index = {
      enableZshIntegration = true;
    };
  };

  services = {
    openssh.enable = true;

    udisks2.enable = true;
    gvfs.enable = config.unravelled.profiles.graphical.enable;
    devmon.enable = true;

    flatpak.enable = config.unravelled.profiles.full.enable;

    auto-cpufreq = {
      enable = true;
      settings = {
        battery = {
          governor = "powersave";
          turbo = "never";
        };
        charger = {
          governor = "performance";
          turbo = "auto";
        };
      };
    };
    upower.enable = true;

    ollama = {
      enable = config.unravelled.profiles.perf.high.enable;
      package = mkDefault pkgs.ollama-vulkan;
    };
  };

  security = {
    polkit.enable = true;
    rtkit.enable = true;
    sudo-rs.enable = true;
  };

  hardware = {
    enableRedistributableFirmware = true;
    graphics = mkIf config.unravelled.profiles.graphical.enable {
      enable = true;
      enable32Bit = true;
    };
  };

  documentation.dev.enable = false;
}
