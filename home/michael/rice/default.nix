{ pkgs, ... }: {
  imports = [
    ./hyprland
    ./shell
    ./gtk
    ./kitty
    ./cava.nix
    ./waybar
    ./wofi.nix
  ];

  home.packages = with pkgs; [
  ];
}
