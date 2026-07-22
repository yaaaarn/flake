{ pkgs, ... }:
{
  programs.waybar.settings.mainBar."wlr/taskbar".format = "{icon} {title:.25}";

  home.packages = with pkgs; [
    steam
    osu-lazer-bin
    prismlauncher
    lutris 
  ];
}
