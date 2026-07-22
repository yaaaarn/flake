{ ... }: {
  networking.firewall.allowedTCPPorts = [
    6667
  ];

  services.soju = {
    enable = true;
    hostName = "bento.char-ruler.ts.net";
    listen = [ "irc+insecure://0.0.0.0" ];
  };
}
