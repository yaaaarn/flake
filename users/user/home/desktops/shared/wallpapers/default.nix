{ osConfig, ... }:
{
  home.file."Pictures/wallpaper" = {
    source = ./${osConfig.unravelled.options.wallpaper};
    recursive = true;
  };
}
