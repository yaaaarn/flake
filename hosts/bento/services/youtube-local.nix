{ ... }:
{
  networking.firewall.allowedTCPPorts = [
    4545
  ];

  services.youtube-local = {
    enable = true;
    allowForeignAddresses = true;
    port = 4545;
    theme = 2;
    routeTor = 0;
    defaultResolution = 1080;
    useSponsorblockJs = true;
    subtitlesMode = 1;
  };
}
