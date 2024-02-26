{ pkgs, ... }: {
  programs.vscode = {
    enable = true;
    extensions = with pkgs.vscode-extensions; [
      catppuccin.catppuccin-vsc
      bbenoist.nix
      jnoortheen.nix-ide
    ];

    userSettings = {
      "workbench.colorTheme" = "Catppuccin Macchiato";

      "editor.semanticHighlighting.enabled" = true;
      "terminal.integrated.minimumContrastRatio" = 1;
      "window.titleBarStyle" = "custom";
      "explorer.confirmDelete" = false;
    };
  };

}
