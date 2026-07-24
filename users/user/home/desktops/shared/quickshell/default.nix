{
  self',
  pkgs,
  colors,
  secrets,
  ...
}:
let
  x = colors.x;

  xArray = builtins.concatStringsSep ", " (map (c: "\"#${c}\"") x);

  varsQml = pkgs.writeText "Vars.qml" ''
    import QtQml

    QtObject {
        readonly property string crust: "#${colors.crust}"
        readonly property string background: "#${colors.background}"
        readonly property string foreground: "#${colors.foreground}"
        readonly property string surface: "#${colors.surface}"
        readonly property string foregroundAlt: "#${colors.foreground-alt}"
        readonly property var x: [${xArray}]
        readonly property string uploadUrl: "${secrets.uploadUrl}"
        readonly property string uploadPassword: "${secrets.uploadPassword}"
    }
  '';

  configDir = pkgs.runCommand "quickshell-config" { } ''
    mkdir -p $out/vars
    cp -r ${./cfg}/* $out/
    cp ${varsQml} $out/vars/Vars.qml
  '';
in
{
  programs.quickshell = {
    enable = true;
    systemd.enable = true; 
    configs.default = configDir;
    activeConfig = "default";
  };

  home.packages = with pkgs; [
    imagemagick # needed for screenshot tool
  ];
}
