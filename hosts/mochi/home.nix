{ pkgs, self, ... }:
{
  services.wbg.image = "${self}/wallpapers/IMG_5120-dithered.png";

  home.packages = with pkgs; [
    steam
    osu-lazer-bin
    prismlauncher
    lutris
  ];
}
