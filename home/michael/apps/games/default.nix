{ pkgs, ... }: let

in {
  home.packages = [
    pkgs.prismlauncher
  ];
}