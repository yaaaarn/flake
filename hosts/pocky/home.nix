{ pkgs, ... }:
{
  wayland.windowManager.labwc.autostart = [
    "wlr-randr --output eDP-1 --scale 1.75 &"
  ];

  programs.niri.settings.outputs."eDP-1".scale = 1.75;

  home.packages = with pkgs; [
    steam
    osu-lazer-bin
  ];
}
