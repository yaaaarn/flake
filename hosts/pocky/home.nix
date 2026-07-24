{ pkgs, self, ... }:
{
  wayland.windowManager.labwc.autostart = [
    "wlr-randr --output eDP-1 --scale 1.75 &"
  ];

  programs.niri.settings.outputs."eDP-1".scale = 1.75;

  services.wbg.image = "${self}/wallpapers/reisa-401361.jpg";

  home.packages = with pkgs; [
    steam
    osu-lazer-bin
  ];

  unravelled.apps.browsers.default = "firefox";
}
