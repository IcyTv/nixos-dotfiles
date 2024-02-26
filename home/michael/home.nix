{ inputs, ... }: {
  home = {
    username = "michael";
    homeDirectory = "/home/michael";
    stateVersion = "23.11";
  };

  programs = {
    home-manager.enable = true;
  };

  imports = [
    ./themes
    ./rice
    ./apps
    ./system
  ];

  nixpkgs = {
    config = {
      allowUnfree = true;
    };
  };

  fonts.fontconfig.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
