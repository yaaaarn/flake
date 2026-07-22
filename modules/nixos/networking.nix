{ pkgs, self', ... }:
let
  dns = [
    "1.1.1.1"
    "1.0.0.1"
  ];
in
{
  environment.systemPackages = with pkgs; [
    impala
    self'.packages.tsui 
  ];

  services = {
    tailscale.enable = true;

    resolved = {
      enable = true;
      settings = {
        Resolve = {
          DNSOverTLS = true;
          DNSSEC = "allow-downgrade";
          Domains = [ "~." ];
          FallbackDNS = dns;
        };
      };
    };
  };

  networking = {
    nameservers = dns;

    nftables.enable = true;

    firewall = {
      checkReversePath = "loose";
      allowedTCPPorts = [
        8384
        22000
      ];
      allowedUDPPorts = [ 22000 ];
    };

    wireless.iwd = {
      enable = true;
      settings = {
        Settings.AutoConnect = true;

        General = {
          AddressRandomization = "network";
          AddressRandomizationRange = "full"; 
          EnableNetworkConfiguration = true;
        };

        Network = {
          EnableIPv6 = false;
          RoutePriorityOffset = 1500;
        };
      };
    };
  };

}
