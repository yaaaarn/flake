{ pkgs, lib, self', ... }:
let
  inherit (lib) getExe;
in
{
  programs.zsh = {
    enable = true;

    enableCompletion = true;
    # autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    
    oh-my-zsh = {
      enable = true;
      plugins = ["colored-man-pages"];
    };

    plugins = [
      {
        name = "zsh-clean";
        src = pkgs.fetchFromGitHub {
          owner = "yaaaarn";
          repo = "zsh-clean";
          rev = "0283bb7b147b37e2061d266f78ed2c6a11d4d8f4";
          sha256 = "sha256-UQNM7DbTjA+YCvqolcgHFhKfSMU0H8tFWLUAGyVBuc0="; 
        };
        file = "clean.plugin.zsh";
      }
    ];

    initContent = ''
      export DO_NOT_TRACK=1

      stty sane

      eval "$(${getExe pkgs.deja} init zsh)"

      ${getExe self'.packages.yarnfetch} 
    '';
  };
}
