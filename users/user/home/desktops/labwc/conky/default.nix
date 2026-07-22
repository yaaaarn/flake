{ pkgs, ... }: {
  home.packages = with pkgs; [
    conky
  ];

  home.file.".config/conky/conky.conf" = {
    source = ./conky.conf;
    recursive = true;
  };

  wayland.windowManager.labwc.autostart = [
    "conky &"
  ];
}
