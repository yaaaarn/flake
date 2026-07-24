{
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  environment = {
    systemPackages = with pkgs; [
      gpu-switch
    ];

    sessionVariables = {
      LIBVA_DRIVER_NAME = "radeonsi";
      VDPAU_DRIVER = "radeonsi";
    };
  };

  swapDevices = [
    {
      device = "/var/lib/swapfile";
      size = 16 * 1024;
    }
  ];

  services = {
    logind.settings.Login = {
      HandlePowerKey = "ignore";
      HandleSuspendKey = "ignore";
      HandleLidSwitch = "ignore";
      HandleLidSwitchExternalPower = "ignore";
      HandleLidSwitchDocked = "ignore";
    };

    mbpfan.enable = true;
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "intel_iommu=off"
      "libata.force=1:noncq"
      "acpi_mask_gpe=0x06"
      "acpi_osi=Darwin"
      "radeon.cik_support=0"
      "amdgpu.cik_support=1"
      "amdgpu.dc=1"
      "amdgpu.runpm=1"
      "amdgpu.dcdebugmask=0x10"
      "amdgpu.enable_psr=1"
      "brcmfmac.feature_disable=0x82000"
    ];

    kernelModules = [
      "brcmfmac"
      "applesmc"
      "apple-gmux"
      "msr"
    ];
  };

  hardware = {
    facetimehd = {
      enable = true;
      withCalibration = true;
    };

    cpu.intel.microcodePackage = pkgs.microcode-intel;

    amdgpu = {
      initrd.enable = true;
      legacySupport.enable = true;
      opencl.enable = true;
    };
  };

  systemd.services.disable-bd-prochot = {
    description = "Disable BD PROCHOT";
    wantedBy = [
      "multi-user.target"
      "post-resume.target"
    ];
    after = [
      "multi-user.target"
      "post-resume.target"
    ];
    path = with pkgs; [ msr-tools ];

    script = ''
      current=$(rdmsr -d 0x1FC)
      if [ $((current & 1)) -eq 0 ]; then
        echo "BD PROCHOT already disabled"
        exit 0
      fi
      wrmsr -a 0x1FC $((current & ~1))
    '';

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };
}
