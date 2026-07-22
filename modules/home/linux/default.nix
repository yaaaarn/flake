{
  lib,
  osConfig,
  pkgs,
  ...
}:
let
  inherit (lib) mkIf getExe;
in
{
  imports = [ ./wallpaper.nix ];

  xdg = mkIf osConfig.unravelled.profiles.graphical.enable {
    portal = {
      enable = true;
      config = {
        common = {
          default = [ "gtk" ];
          "org.freedesktop.impl.portal.ScreenCast" = [ "gnome" ];
          "org.freedesktop.impl.portal.Screenshot" = [ "gnome" ];
          "org.freedesktop.impl.portal.Secret" = [ "gnome-keyring" ];
        };
      };
      extraPortals = [
        pkgs.xdg-desktop-portal-gtk
        pkgs.xdg-desktop-portal-gnome
      ];
      xdgOpenUsePortal = true;
    };
    userDirs = {
      enable = true;
      createDirectories = true;
    };
    terminal-exec.enable = osConfig.unravelled.profiles.graphical.enable;
    mimeApps.enable = osConfig.unravelled.profiles.graphical.enable;
  };

  home.packages =
    with pkgs;
    lib.mkIf osConfig.unravelled.profiles.graphical.enable [
      gnome-keyring

      # quick n painless default terminal
      (pkgs.writeShellScriptBin "xterm" ''
        exec ${getExe pkgs.xdg-terminal-exec} "$@"
      '')
    ];
  systemd.user.services.polkit-gnome-authentication-agent-1 =
    mkIf osConfig.unravelled.profiles.graphical.enable
      {
        Unit = {
          Description = "polkit-gnome-authentication-agent-1";
          Wants = [ "graphical-session.target" ];
          After = [ "graphical-session.target" ];
        };
        Install = {
          WantedBy = [ "graphical-session.target" ];
        };
        Service = {
          Type = "simple";
          ExecStart = "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1";
          Restart = "on-failure";
          RestartSec = 1;
          TimeoutStopSec = 10;
        };
      };

  services = {
    playerctld.enable = osConfig.unravelled.profiles.graphical.enable;
    clipcat = {
      enable = osConfig.unravelled.profiles.graphical.enable;
      enableSystemdUnit = true;
      enableZshIntegration = true;
    };
  };
}
