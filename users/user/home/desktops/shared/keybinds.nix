{ pkgs, config }:
let
  inherit (pkgs) rofi rofimoji xdg-utils xdg-terminal-exec gtk3 clipcat quickshell wireplumber playerctl brightnessctl;
  inherit (pkgs) lib;
  fileManager = builtins.elemAt config.xdg.mimeApps.defaultApplications."inode/directory" 0;
in
{
  terminal = [ (lib.getExe xdg-terminal-exec) ];
  browser = [ (lib.getExe' xdg-utils "xdg-open") "https://" ];
  fileManager' = [ (lib.getExe' gtk3 "gtk-launch") fileManager ];
  rofi = [ (lib.getExe rofi) "-show" "drun" ];
  rofimoji = [ (lib.getExe rofimoji) "-a" "copy" "-r" "emoji" "--use-icons" ];
  clipboard = [ (lib.getExe' clipcat "clipcat-menu") ];
  sidebar = [ (lib.getExe quickshell) "ipc" "call" "sidebar" "toggle" ];
  screenshot = [ (lib.getExe quickshell) "ipc" "call" "screenshot" "screenshotToClipboard" ];
  screenshotUpload = [ (lib.getExe quickshell) "ipc" "call" "screenshot" "screenshotAndUpload" ];

  volumeUp = "${lib.getExe' wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.05+";
  volumeDown = "${lib.getExe' wireplumber "wpctl"} set-volume @DEFAULT_AUDIO_SINK@ 0.05- -l 1.0";
  mute = "${lib.getExe' wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SINK@ toggle";
  micMute = "${lib.getExe' wireplumber "wpctl"} set-mute @DEFAULT_AUDIO_SOURCE@ toggle";

  playerPlay = [ (lib.getExe playerctl) "play-pause" ];
  playerStop = [ (lib.getExe playerctl) "stop" ];
  playerPrev = [ (lib.getExe playerctl) "previous" ];
  playerNext = [ (lib.getExe playerctl) "next" ];

  brightnessUp = "${lib.getExe brightnessctl} --class=backlight set +5%";
  brightnessDown = "${lib.getExe brightnessctl} --class=backlight set 5%-";
  kbdBrightnessUp = "${lib.getExe brightnessctl} -d smc::kbd_backlight set +5%";
  kbdBrightnessDown = "${lib.getExe brightnessctl} -d smc::kbd_backlight set 5%-";
}
