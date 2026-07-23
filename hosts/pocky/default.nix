{ pkgs, ... }: {
  imports = [ ./hardware-configuration.nix ];
  environment = {
    systemPackages = with pkgs; [ gpu-switch ];
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
    mbpfan = {
      enable = true;
      aggressive = true;
      settings = {
        general = {
          low_temp = 50;
          high_temp = 60;
          max_temp = 75;
          polling_interval = 1;
        };
      };
    };
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
    wantedBy = [ "multi-user.target" ];
    after = [ "sys-kernel-config.mount" ];
    path = [
      pkgs.msr-tools
      pkgs.kmod
    ];
    script = ''
      modprobe msr
      wrmsr -a 0x1FC 0x1e
    '';
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
  };

  unravelled.preservation.enable = true;
}
