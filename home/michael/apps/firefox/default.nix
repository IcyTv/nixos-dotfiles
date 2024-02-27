{ pkgs, ... }: {
  imports = [
    ./profile-switcher.nix
  ];

  programs.firefox = {
    enable = true;
    package = (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { pipewireSupport = true;}) {});
  };
}
