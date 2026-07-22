{
  pkgs,
  secrets,
  config,
  lib,
  ...
}:
let
  cinnyConfig = {
    defaultHomeserver = 0;
    homeserverList = [
      "mx.yarncat.moe"
      "unredacted.org"
    ];
    allowCustomHomeservers = false;
  };
in
{
  networking.firewall.allowedTCPPorts = [
    1337
  ];

  services.matrix-continuwuity = {
    enable = true;
    admin.enable = config.services.matrix-continuwuity.enable;

    settings.global = {
      server_name = "mx.yarncat.moe";
      address = [ "0.0.0.0" ];
      allow_registration = false;
      allow_encryption = true;
      allow_federation = true;
      trusted_servers = secrets.matrixTrustedServers;
      new_user_displayname_suffix = "";
      well_known = {
        client = "https://mx.yarncat.moe";
        server = "mx.yarncat.moe:443";
      };
      max_request_size = 50000000;
      request_timeout = 120;
      url_preview_domain_contains_allowlist = secrets.matrixAllowedURLs;
    };
  };

  services.nginx = {
    enable = true;
    virtualHosts."cinny" = {
      root = pkgs.cinny;

      listen = [
        {
          addr = "0.0.0.0";
          port = 1337;
        }
      ];

      locations = {
        "/.well-known/matrix/" = {
          proxyPass = "http://127.0.0.1:6167";
        };

        "/_matrix/" = {
          proxyPass = "http://127.0.0.1:6167";
        };

        "= /config.json".extraConfig = ''
          default_type application/json;
          return 200 '${lib.strings.toJSON cinnyConfig}';
        '';

        "/".extraConfig = ''
          rewrite ^/config.json$ /config.json break;
          rewrite ^/manifest.json$ /manifest.json break;
          rewrite ^/sw.js$ /sw.js break;
          rewrite ^/pdf.worker.min.js$ /pdf.worker.min.js break;
          rewrite ^/public/(.*)$ /public/$1 break;
          rewrite ^/assets/(.*)$ /assets/$1 break;
          rewrite ^(.+)$ /index.html break;
        '';
      };
    };
  };
}
