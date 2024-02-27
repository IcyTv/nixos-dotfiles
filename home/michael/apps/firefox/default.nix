{ pkgs, lib, ... }:
let

in {
  # programs.firefox = {
  #   enable = true;
  #   # package = (pkgs.wrapFirefox (pkgs.firefox-unwrapped.override { 
  #   #   pipewireSupport = true;
  #   # }) {});
  #   package = pkgs.firefox;
  #   nativeMessagingHosts = [ 
  #     # (pkgs.callPackage ./profile-switcher.nix {})
  #   ];
  #   # forceWayland = true;
  # };

  home.packages = with pkgs; [
    (firefox.override {
      nativeMessagingHosts = [
        (pkgs.callPackage ./profile-switcher.nix {})
      ];
    })
  ];
}
