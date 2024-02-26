_: {
  program.gh = {
    enable = true;
    settings = {
      git_protocol = "ssh";
      editor = "code --wait .";
    };
  };

  programs.gh-dash.enable = true;
}