{ inputs, ... }: {
  imports = [
    ./general.nix
    ../hardware-configuration.nix
    ../modules/username.nix
    ../modules/virtualization.nix
  ];
  username = "michael";
  hostname = "nixos";

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
}