{ pkgs, secrets, ... }:
{
  programs.beets.enable = true;

  services.qbittorrent = {
    enable = true;
    webuiPort = 6767;
    torrentingPort = 6969;
    serverConfig = {
      Preferences = {
        WebUI = {
          Username = "catty";
          Password_PBKDF2 = secrets.qbittorrentPasswordHash;
          AlternativeUIEnabled = true;
          RootFolder = "${pkgs.vuetorrent}/share/vuetorrent";
        };
      };
    };
  };

  services.syncthing.guiAddress = "0.0.0.0:8384";

  services.parados = {
    enable = true;

    settings = {
      media_dir = "/Users/user/Documents/Media";
      server_addr = "0.0.0.0";
      server_port = 8067;
      verbose_log = true;
      cors_origin = "http://127.0.0.1:8067";
      http_io_timeout = 15;
      max_clients = 128;
      auth_delay = 500;
    };

    users = {
      catty = {
        password = secrets.paradosPassword;
        allow = [ "*" ];
      };
    };
  };
}
