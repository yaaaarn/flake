{
  config,
  pkgs,
  ...
}:
{
  imports = [
    ./hardware-configuration.nix
  ];

  hardware = {
    nvidia = {
      modesetting.enable = true;

      powerManagement.enable = true;
      powerManagement.finegrained = false;

      open = false;
      nvidiaSettings = true;
      package = config.boot.kernelPackages.nvidiaPackages.stable;
    };

    cpu.intel.microcodePackage = pkgs.microcode-intel;
  };

  services.ollama.package = pkgs.ollama-cuda; 
}
