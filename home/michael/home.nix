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
    overlays = [ 
      inputs.rust-overlay.overlays.default
      inputs.nur.overlay  
    ];
  };

  dconf.settings = {
    "org/gnome/desktop/interface" = {
      color-scheme = "prefer-dark";
    };
  };

  fonts.fontconfig.enable = true;

  home.sessionPath = [
    "$HOME/.local/bin"
  ];
}
