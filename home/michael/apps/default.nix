{ pkgs, ... }: {
  imports = [
    ./firefox
    ./vscode
    ./discord
    ./spotify.nix
    ./fzf.nix
    ./git.nix
    ./thunar.nix
    ./github.nix
    ./cli.nix
    ./uni.nix
    ./games
  ];

  home.packages = with pkgs; [
    nixpkgs-fmt
    jq
    ripgrep
    playerctl
    pavucontrol
    dunst
    polkit_gnome
    sbctl
    wl-clipboard
    pkgs.gnome.gnome-clocks
    whatsapp-for-linux
  ];

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 49.0;
    longitude = 8.4;

    dawnTime = "8:00-8:45";
    duskTime = "22:15-23:30";

    tray = true;

    temperature = {
      day = 6500;
      night = 1800;
    };

    settings = {
      general = {
        adjustment-method = "wayland";
        brightness-day = "1.0";
        brightness-night = "0.8";
      };
    };
  };
}
