{ inputs, pkgs, lib, config, modulesPath, ... }: {
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ./general.nix
    ../modules/username.nix
    ../modules/virtualization.nix
  ];
  username = "michael";
  hostname = "nixos";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;

  hardware.opengl.extraPackages = [ pkgs.libvdpau-va-gl ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" "i2c-dev" "i2c-piix4" ];
  boot.extraModulePackages = [ ];

  fileSystems."/" =
    {
      device = "/dev/disk/by-uuid/9dcb1481-c4e6-44a3-819a-35e614c05d8e";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    {
      device = "/dev/disk/by-uuid/D113-7EE6";
      fsType = "vfat";
    };

  fileSystems."/mnt/windows" = {
    device = "/dev/nvme0n1p2";
    fsType = "ntfs";
    options = [
      "defaults"
      "silent"
      "nosuid"
      "noauto"
    ];
  };

  fileSystems."/mnt/data" = {
    device = "/dev/sda2";
    fsType = "ntfs";
    options = [
      "defaults"
      "silent"
      "noauto"
    ];
  };

  swapDevices =
    [{ device = "/dev/disk/by-uuid/7073fb9d-b8e0-44de-ad5b-e13c7ebe1329"; }];

  # Enables DHCP on each ethernet and wireless interface. In case of scripted networking
  # (the default) this is the recommended approach. When using systemd-networkd it's
  # still possible to use this option, but it's recommended to use it in conjunction
  # with explicit per-interface declarations with `networking.interfaces.<interface>.useDHCP`.
  networking.useDHCP = lib.mkDefault true;
  # networking.interfaces.enp42s0.useDHCP = lib.mkDefault true;
  # networking.interfaces.wlo1.useDHCP = lib.mkDefault true;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;

    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  environment.etc."gbm/nvidia-drm_gbm.so".source = "${config.boot.kernelPackages.nvidiaPackages.stable}/lib/libnvidia-allocator.so";

  services.xserver.videoDrivers = [ "nvidia" ];
}