{
  lib,
  config,
  ...
}:
let
  inherit (lib) mkEnableOption mkIf;

  rootDevice = config.fileSystems."/".device;
in
{
  options.unravelled.preservation = {
    enable = mkEnableOption "btrfs impermanence with preservation";
  };

  config = mkIf config.unravelled.preservation.enable {
    fileSystems."/".options = [
      "subvol=root"
      "compress=zstd"
    ];

    fileSystems."/persist" = {
      device = rootDevice;
      fsType = "btrfs";
      options = [
        "subvol=persist"
        "compress=zstd"
      ];
      neededForBoot = true;
    };

    boot.initrd.systemd.services.rollback = {
      description = "Rollback btrfs root to blank snapshot";
      wantedBy = [ "initrd.target" ];
      after = [ "systemd-cryptsetup@luks\\x2dec4eae74\\xcbfa\\x4ce1\\x8601\\x47f5baf7fd7e.service" ];
      before = [ "sysroot.mount" ];
      unitConfig.DefaultDependencies = false;
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir -p /btrfs_tmp
        mount ${rootDevice} /btrfs_tmp
        if [ -e /btrfs_tmp/root ]; then
            btrfs subvolume delete -R /btrfs_tmp/root
        fi
        btrfs subvolume snapshot /btrfs_tmp/root-blank /btrfs_tmp/root
        umount /btrfs_tmp
        rmdir /btrfs_tmp
      '';
    };

    preservation = {
      enable = true;
      preserveAt."/persist" = {
        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
        ];
        directories = [
          "/var/lib/systemd/timers"
          "/var/lib/nixos"
          "/var/log"
        ];
        users.user = {
          commonMountOptions = [
            "x-gvfs-hide"
          ];
          directories = [
            {
              directory = ".ssh";
              mode = "0700";
            }
            ".local/state/nvim"
            ".local/state/wireplumber"
            ".local/state/nix"
            ".local/share/osu"
            ".config/equibop"
            ".mozilla"
            ".gnupg"
            "mail"
            "Documents"
            "Music"
            "Projects"
          ];
        };
      };
    };
    systemd.suppressedSystemUnits = [ "systemd-machine-id-commit.service" ];
  };
}
