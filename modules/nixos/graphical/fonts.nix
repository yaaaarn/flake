{
  lib,
  config,
  pkgs,
  self',
  ...
}:
let
  inherit (lib) mkIf optionals;
in
{
  config = mkIf config.unravelled.profiles.graphical.enable {
    fonts = {
      packages =
        with pkgs;
        [
          twitter-color-emoji
          maple-mono.NF-CN-unhinted
          annotation-mono
          liberation_ttf
          self'.packages.typetr-bitcount
          self'.packages.new-heterodox-mono
        ]
        ++ optionals config.unravelled.profiles.full.enable [
          noto-fonts-cjk-sans
        ];

      fontconfig = {
        enable = true;
        allowBitmaps = true;
        useEmbeddedBitmaps = true;
        defaultFonts = {
          sansSerif = [ "New Heterodox Mono" ];
          serif = [ "New Heterodox Mono" ];
          monospace = [ "New Heterodox Mono" ];
          emoji = [ "Twitter Color Emoji" ];
        };

        localConf = ''
          <?xml version="1.0"?>
          <!DOCTYPE fontconfig SYSTEM "fonts.dtd">
          <fontconfig>
            <match target="scan">
              <test name="family">
                <string>New Heterodox Mono</string>
              </test>
              <edit name="spacing">
                <int>100</int>
              </edit>
            </match>
          </fontconfig> 
        '';
      };
    };
  };
}
