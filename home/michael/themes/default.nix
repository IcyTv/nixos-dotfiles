{ nix-colors, ... }: {
  imports = [
    nix-colors.homeManagerModule
  ];

  colorscheme = nix-colors.colorSchemes.catppuccin-macchiato;
}
