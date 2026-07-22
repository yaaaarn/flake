{ ... }:
{
  networking.firewall.allowedTCPPorts = [
    9405
  ];

  services.cgit."git" = {
    enable = true;
    nginx.virtualHost = "cgit.local";
    scanPath = "/var/lib/git";
    gitHttpBackend.checkExportOkFiles = false;
    settings = {
      remove-suffix = 1;
      enable-git-config = 1;
      root-title = "Local Repositories";
      section-from-path = 3;
    };
  };

  services.nginx.virtualHosts."cgit.local" = {
    listen = [
      {
        addr = "0.0.0.0";
        port = 9405;
      }
    ];
  };
}
