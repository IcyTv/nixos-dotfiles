{ pkgs, ... }: {
  imports = [
    ./firefox
    ./vscode
    ./discord
    ./spotify.nix
    ./fzf.nix
    ./git.nix
    ./gnupg.nix
  ];

  home.packages = with pkgs; [
    nixpkgs-fmt
    jq
    ripgrep
    playerctl
    pavucontrol
    dunst
    polkit_gnome
  ];
}
