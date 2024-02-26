{ ... }: {
  # Home Manager setup
  home.sessionVariables = {
    # only needed for Sway
    XDG_CURRENT_DESKTOP = "sway"; 
  };
}