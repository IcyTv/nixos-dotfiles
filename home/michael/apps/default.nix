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
  ];

  services.gammastep = {
    enable = true;
    provider = "manual";
    latitude = 49.0;
    longitude = 8.4;
  };
}
