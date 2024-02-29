{ pkgs, config, ... }:
let
  catppuccin = pkgs.catppuccin-gtk.override {
    size = "compact";
    accents = [ "blue" ];
    variant = "macchiato";
  };
  theme = "Catppuccin-Macchiato-Compact-Blue-dark";
in
{
  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.apple-cursor;
    name = "macOS-BigSur";
    size = 24;
  };

  gtk = {
    enable = true;
    cursorTheme = {
      name = "macOS-BigSur";
      package = pkgs.apple-cursor;
      size = 24; # Affects gtk applications as the name suggests
    };

    theme = {
      name = theme;
      package = catppuccin;
    };

    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-folders;
    };
  };

  xdg.configFile = {
    "gtk-4.0/assets".source = "${catppuccin}/share/themes/${theme}/gtk-4.0/assets";
    "gtk-4.0/gtk.css".source = "${catppuccin}/share/themes/${theme}/gtk-4.0/gtk.css";
    "gtk-4.0/gtk-dark.css".source = "${catppuccin}/share/themes/${theme}/gtk-4.0/gtk-dark.css";
  };
}
