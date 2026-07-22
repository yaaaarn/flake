[
  { toplevel_name = ">⩊<.ᐟ"; }
  {
    url = "https://github.com/notifications";
    name = "github notifications";
  }
  {
    url = "https://mail.proton.me";
    name = "proton mail";
  }
  {
    name = "0x00 nixos";
    children = [
      {
        url = "https://search.nixos.org/options";
        name = "nixos option search";
      }
      {
        url = "https://mynixos.com";
        name = "mynixos";
      }
      {
        url = "https://search.nixos.org/packages";
        name = "nixpkgs";
      }
      {
        url = "https://nur.nix-community.org";
        name = "nix user respository";
      }
      {
        url = "https://noogle.dev";
        name = "noogle";
      }
      {
        name = "nixvim";
        children = [
          {
            url = "https://nix-community.github.io/nixvim/";
            name = "nixvim docs";

          }
          {
            url = "https://nix-community.github.io/nixvim/search";
            name = "nixvim options search";
          }
        ];
      }

      {
        name = "browser policies";
        children = [
          {
            url = "https://chromeenterprise.google/intl/en-UK/policies/";
            name = "chrome enterprise policy list";
          }
          {
            url = "https://firefox-admin-docs.mozilla.org/reference/policies/";
            name = "firefox administrator reference";
          }
        ];
      }
    ];
  }
  {
    name = "0x01 privacy";
    children = [
      {
        url = "https://privacyguides.org";
        name = "privacy guides";
      }
    ];
  }
  {
    name = "0x02 design";
    children = [
      {
        url = "https://uncut.wtf";
        name = "uncut";
      }
      {
        url = "https://figma.com";
        name = "figma";
      }
      {
        url = "https://fonts.google.com";
        name = "google fonts";
      }
    ];
  }
  {
    name = "0x03 music";
    children = [
      {
        url = "https://bandcamp.com";
        name = "bandcamp";
      }
      {
        url = "https://soundcloud.com";
        name = "soundcloud";
      }
      {
        name = "musicbrainz";
        children = [
          {
            url = "https://musicbrainz.org";
            name = "musicbrainz.org";
          }
          {
            url = "https://listenbrainz.org";
            name = "listenbrainz.org";
          }
          {
            url = "https://yambs.erat.org";
            name = "yambs (yet another musicbrainz seeder)";
          }
          {
            name = "userscripts";
            children = [
              {
                url = "https://musicbrainz.org/doc/Guides/Userscripts";
                name = "userscripts";
              }
              {
                url = "https://github.com/ROpdebee/mb-userscripts";
                name = "mb-userscripts";
              }
            ];
          }
        ];
      }
    ];
  }
  {
    name = "0x04 piracy";
    children = [
      {
        url = "https://lucida.to";
        name = "Lucida";
      }
      {
        url = "https://squid.wtf";
        name = "squid.wtf";
      }
      {
        url = "https://fmhy.net";
        name = "free media, heck yeah";
      }
      {
        url = "https://if-it-runs-ship-it.lol";
        name = "monochrome (if it runs, ship it lol)";
      }
      {
        url = "https://cobalt.tools";
        name = "cobalt";
      }
      {
        url = "https://doujinstyle.com";
        name = "doujinstyle";
      }
      {
        url = "https://antra.hoshi.cfd";
        name = "antra";
      }
    ];
  }
]
