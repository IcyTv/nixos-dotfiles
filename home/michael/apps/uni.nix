{ pkgs, ... }: {
  home.packages = with pkgs; [
    anki
    (texlive.combine {
      inherit (texlive) scheme-medium pgf;
    })
    obsidian
  ];
}