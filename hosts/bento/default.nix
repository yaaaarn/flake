{
  self,
  lib,
  pkgs,
  inputs,
  config,
  ...
}:
let
  inherit (lib) getExe;
in
{
  imports = [
    inputs.nix-minecraft.nixosModules.minecraft-servers

    ./hardware-configuration.nix

    ./modules/youtube-local.nix

    ./services/minecraft.nix
    ./services/cgit.nix
    ./services/matrix.nix
    ./services/youtube-local.nix
    ./services/soju.nix
  ];

  security.acme.acceptTerms = true;

  age.secrets = {
    "cloudflared-creds" = {
      file = "${self}/secrets/cloudflare-creds.age";
      owner = config.unravelled.system.mainUser;
      group = "users";
      mode = "0400";
    };
  };

  environment.systemPackages = with pkgs; [
    fastfetch
  ];

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 8 * 1024;
    }
  ];

  systemd = {
    services.cmatrix = {
      description = "cmatrix";

      after = [ "local-fs.target" ];
      wantedBy = [ "multi-user.target" ];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${getExe pkgs.cmatrix}";

        StandardInput = "tty-fail";
        StandardOutput = "tty";
        StandardError = "journal";
        TTYPath = "/dev/tty1";

        TTYReset = true;
        TTYVHangup = true;

        Restart = "always";
        RestartSec = 3;
      };
    };

    services."getty@tty1".enable = false;
    services."autovt@tty1".enable = false;
  };

  boot = {
    kernelPackages = pkgs.linuxKernel.packages.linux_zen;
    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
      "net.ipv6.conf.all.forwarding" = 1;
    };
  };

  services.cloudflared = {
    enable = true;
    tunnels = {
      "1ff06930-f08a-4609-b2bd-ebeb39d8f342" = {
        credentialsFile = config.age.secrets.cloudflared-creds.path;

        ingress = {
          "mx.yarncat.moe" = "http://localhost:1337";
          "chat.yarncat.moe" = "http://localhost:9406";
        };

        default = "http_status:404";
      };
    };
  }; 
}
