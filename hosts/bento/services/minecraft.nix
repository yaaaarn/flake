{ pkgs, ... }:
let
  inherit (pkgs) fetchurl;
in
{
  networking.firewall.allowedTCPPorts = [
    19132
  ];

  networking.firewall.allowedUDPPorts = [
    19132
  ];

  services.minecraft-servers = {
    enable = false;
    eula = true;
    openFirewall = true;
    managementSystem.systemd-socket.enable = true;
    servers.fabric = {
      enable = true;

      package = pkgs.fabricServers.fabric-26_1_2.override { jre_headless = pkgs.openjdk25_headless; };

      symlinks = {
        mods = pkgs.linkFarmFromDrvs "mods" (
          builtins.attrValues {
            Geyser = fetchurl {
              url = "https://cdn.modrinth.com/data/wKkoqHrH/versions/NL79aglD/Geyser-Fabric-2.10.1-b1174.jar";
              sha512 = "1ee02871e7f6f0d59aa9313537ddd2ffcf0ccf22c2c0cf0cfc20b3932f39e2b363257c317d3e36e6c24d67086372bfc4d838b181349475bd35865d122ff9e056";
            };
            Floodgate = fetchurl {
              url = "https://cdn.modrinth.com/data/bWrNNfkb/versions/fD4J9lnX/Floodgate-Fabric-2.2.6-b63.jar";
              sha512 = "54874033236df688da15fd4dd7d2d99d002e8955cb2d788d5ba409d753eb17629f53a6e976992de8cca8c8dd3663c70b283da88b5a12d72cef9647d09e04ae62";
            };
            Fabric-API = fetchurl {
              url = "https://cdn.modrinth.com/data/P7dR8mSH/versions/WC1KT7Yg/fabric-api-0.153.0%2B26.1.2.jar";
              sha512 = "4e31da3c796714d25ca079e5277980c5439bb09dcad33d1224cccdfec6000b776ba5d16323a9c312682e773bddedae75aa697a7c0f4ad2b77b5b11ba679b480a";
            };
            AppleSkin = fetchurl {
              url = "https://cdn.modrinth.com/data/EsAfCjCV/versions/zLlqqiTA/appleskin-fabric-mc26.1.2-3.0.10.jar";
              sha512 = "eacb134cc9e03a4fd870c3e75fedd3fba6ef9bf1611dcff5b89f0d35b22bda5709f085436ac071c018cf7d3e5a54c9783477c4f091d4ded74deb5292f25f5644";
            };
            Roughly-Enough-Items = fetchurl {
              url = "https://cdn.modrinth.com/data/nfn13YXA/versions/EAlqUmgQ/RoughlyEnoughItems-26.1.819.jar";
              sha512 = "91478d2c27359f3637cd30408f38b10579a8c9cdc0f1e61ab69b07550ee0a60dafccdb593bf1253a21f2dc32af5099610107094a5c6096c82a5ee0c23879a56b";
            };
            FerriteCore = fetchurl {
              url = "https://cdn.modrinth.com/data/uXXizFIs/versions/d5ddUdiB/ferritecore-9.0.0-fabric.jar";
              sha512 = "d81fa97e11784c19d42f89c2f433831d007603dd7193cee45fa177e4a6a9c52b384b198586e04a0f7f63cd996fed713322578bde9a8db57e1188854ae5cbe584";
            };
            Lithium = fetchurl {
              url = "https://cdn.modrinth.com/data/gvQqBUqZ/versions/fQBdPR1m/lithium-fabric-0.24.6%2Bmc26.1.2.jar";
              sha512 = "fac351f5b6150889b9355a01889c35b5798147d4bedb291594a590a2d41909eb8dc494ef0051317bf55886f2fc7fe134abbe2e755098df38473edb2bf43357e9";
            };
            Architectury-API = fetchurl {
              url = "https://cdn.modrinth.com/data/lhGA9TYQ/versions/fe6U0jSg/architectury-fabric-20.0.7.jar";
              sha512 = "440f904211cf4889d8a9f39b544556b485052cdf746caef061a4765dcc51a50b654d2c0c0257a836c48ba54d4eb8c7af1d47f87249cb39b623d4a09af34cc11c";
            };
            Death-Chest = fetchurl {
              url = "https://cdn.modrinth.com/data/iwfWTa7P/versions/W5O7gIx8/bib-death-chest-0.2.jar";
              sha512 = "5c79be98be428c03da5a78b8e0b5857fd6698f60bb18eb1f33e8e3b1fcf526880c31617c48c5bee986973c906b7b7f5c1dce1edcd001fb445f643541347e42dc";
            };
            Simple-Warp-Tpa-Home = fetchurl {
              url = "https://cdn.modrinth.com/data/4Ywm3d1c/versions/5OhkBjB7/simple-warp-tpa-home-26.1.2-1.0.0.jar";
              sha512 = "e3b0ac9f39c84877732d662e24845ba066f690eb113e368267a2f298d280f7b33a6075386056ba7eb2712ac34dc8a7c3ccb8188e8486bbf3e181911a301186e4";
            };
            Tree-Harvester = fetchurl {
              url = "https://cdn.modrinth.com/data/abooMhox/versions/PIkMhpKe/treeharvester-26.1.2-9.4.jar";
              sha512 = "dc566fa4334a9fe71a6069b5529d01729c3524403da8e939a5c2c22b031941f54c93c0b202bb1acf220869317eaca7cbb7835caf3ea58f4d428661c9cdb7cff1";
            };
            Ore-Harvester = fetchurl {
              url = "https://cdn.modrinth.com/data/Xiv4r347/versions/abQzmnQh/oreharvester-26.1.2-1.6.jar";
              sha512 = "b337e88c811875b4b5d0f586ace254f7135a979967bdd9e87d4efd508c14085bed7aea2d91b90163b903b11828428a2267c04b220edad67bf000f798eb9ce4d1";
            };
            Collective = fetchurl {
              url = "https://cdn.modrinth.com/data/e0M1UDsY/versions/iXqgYZEw/collective-26.1.2-8.32.jar";
              sha512 = "4eb163cb4c4428a0f74dfe4a6571c831fdcb45a5465e71e7d3ac6d20ba28f72c6a6d7a94a41cd2f9781949655b17513755e2b71aa394c31cfe38e0f9c062d7d1";
            };
          }
        );
      };

      files = {
        "config/Geyser-Fabric/config.yml" = {
          value = {
            bedrock = {
              address = "0.0.0.0"; # Uncomment if you want to limit what IPs can connect
              port = 19132;
              clone-remote-port = false;
              motd1 = "join fr";
              motd2 = "fuckass minecraft server";
              server-name = "shitty smp";
              compression-level = 6;
              # broadcast-port = 19132;
              enable-proxy-protocol = false;
              # proxy-protocol-whitelisted-ips = [ "127.0.0.1" "172.18.0.0/16" "https://example.com/whitelist.txt" ];
            };

            remote = {
              address = "auto";
              port = 25565;
              auth-type = "online";
              use-proxy-protocol = false;
              forward-hostname = false;
            };

            floodgate-key-file = "key.pem";

            pending-authentication-timeout = 120;
            command-suggestions = true;

            passthrough-motd = true;
            passthrough-player-counts = true;
            legacy-ping-passthrough = false;
            ping-passthrough-interval = 3;

            forward-player-ping = false;
            max-players = 100;
            debug-mode = false;
            show-cooldown = "title";
            show-coordinates = true;
            disable-bedrock-scaffolding = false;
            emote-offhand-workaround = "disabled";
            # default-locale = "en_us";

            cache-images = 0;
            allow-custom-skulls = true;
            max-visible-custom-skulls = 128;
            custom-skull-render-distance = 32;
            add-non-bedrock-items = true;
            above-bedrock-nether-building = false;
            force-resource-packs = true;
            xbox-achievements-enabled = false;
            log-player-ip-addresses = true;
            notify-on-new-bedrock-update = true;
            unusable-space-block = "minecraft:barrier";

            scoreboard-packet-threshold = 20;
            enable-proxy-connections = false;
            mtu = 1400;
            use-direct-connection = true;
            disable-compression = true;

            config-version = 4;
          };
        };
      };
    };
  };

}
