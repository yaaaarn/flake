{ osConfig, ... }:
{
  home.file."Pictures/wallpaper" = {
    source = ./${osConfig.unravelled.apps.wallpaper};
    recursive = true;
  };
}
