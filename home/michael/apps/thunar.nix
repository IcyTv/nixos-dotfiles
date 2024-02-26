{ pkgs, ... }: let
  thunarPlugins = with pkgs; [
    xfce.thunar-volman
    xfce.thunar-archive-plugin
    xfce.thunar-media-tags-plugin
  ];
in {
  home.packages = with pkgs; [
    (xfce.thunar.override { inherit thunarPlugins; })
    xfce.tumbler
  ];

  # programs.thunar = {
  #   enable = true;
  #   plugins = with pkgs.xfce; [
  #     thunar-archive-plugin
  #     thunar-volman
  #   ];
  # };

  # services.tumbler.enable = true; # Thumbnail support
  # services.gvfs.enable = true; # Trash, Mount, etc.
}