{
  lib,
  pkgs,
  osConfig,
  self',
  secrets,
  ...
}:
let
  inherit (lib) optionals;
in
{
  programs = {
    btop = {
      enable = true;
      settings = {
        color_theme = "TTY";
      };
    };

    git.enable = true;
    bun.enable = true;
    go.enable = true;
    npm.enable = true;
    opencode.enable = true;

    senpai = {
      enable = true;
      config = {
        nickname = "yarn";
        password-cmd = [
          "cat"
          osConfig.age.secrets.soju-password.path
        ];
        address = "irc+insecure://bento.char-ruler.ts.net:6667";
      };
    };

    rbw = {
      enable = true;
      settings = {
        email = secrets.bitwardenEmail;
        base_url = secrets.bitwardenBaseUrl;
        lock_timeout = 300;
        pinentry = pkgs.pinentry-gnome3;
      };
    }; 
  };

  home.packages =
    with pkgs;
    [
      deno
      glow
      nix-output-monitor
      uv
      python3
      ncdu
      (if stdenv.isLinux then rustnet else snitch)
      whosthere

      ffmpeg
      yt-dlp

      self'.packages.downcloud
      self'.packages.nyaa
      self'.packages.yarnfetch
      self'.packages.banded
    ]
    ++ optionals (osConfig.unravelled.profiles.full.enable) [
      javaPackages.compiler.openjdk25
      nixpkgs-review
      delta

      self'.packages.tetro-tui
    ];
}
