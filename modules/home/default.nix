{
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) getExe mkDefault;

  locale = "en_US.UTF-8";
in
{
  imports = [
    ./modules
  ]
  ++ (
    if pkgs.stdenv.isDarwin then
      [ ./darwin ]
    else if pkgs.stdenv.isLinux then
      [ ./linux ]
    else
      [ ]
  );

  home.stateVersion = "26.05";

  programs.git = {
    enable = true;
    settings = {
      core = {
        pager = "${getExe pkgs.delta}";
      };
      interactive = {
        diffFilter = "${getExe pkgs.delta} --color-only";
      };
      delta = {
        navigate = true;
        dark = true;
        side-by-side = true;
        line-numbers = true;
      };
      merge = {
        conflictstyle = "zdiff3";
      };
    };
  };

  home.sessionVariables = {
    LANG = mkDefault locale;
    LC_ADDRESS = mkDefault locale;
    LC_IDENTIFICATION = mkDefault locale;
    LC_MEASUREMENT = mkDefault locale;
    LC_MONETARY = mkDefault locale;
    LC_NAME = mkDefault locale;
    LC_NUMERIC = mkDefault locale;
    LC_PAPER = mkDefault locale;
    LC_TELEPHONE = mkDefault locale;
    LC_TIME = mkDefault locale;
  };
}
