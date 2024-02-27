# { pkgs, ... }: let
#   src = pkgs.fetchFromGitHub {
#     owner = "null-dev";
#     rev = "0c4bf355f05c4cb9c0b740c1ddd4f2633300231e";
#     repo = "firefox-profile-switcher-connector";
#   }
# in {

# }

{ pkgs, lib, ... }:
let
  rustPlatform = pkgs.makeRustPlatform {
    cargo = pkgs.rust-bin.stable.latest.minimal;
    rustc = pkgs.rust-bin.stable.latest.minimal;
  };
  profileSwitcherPackage = rustPlatform.buildRustPackage rec {
    pname = "firefox-profile-switcher";

    version = "v0.1.1";

    src = pkgs.fetchFromGitHub {
      owner = "null-dev";
      rev = "0c4bf355f05c4cb9c0b740c1ddd4f2633300231e";
      repo = "firefox-profile-switcher-connector";
      sha256 = "sha256-s94o1viLg3dlyBWhp6l40v6/aGFWkjHvp6wsnVtdotE=";
    };

    nativeBuildInputs = [ pkgs.cmake pkgs.pkg-config ];
    buildInputs = [ pkgs.gtk3 ];

    cargoSha256 = "sha256-QfeklKHsY3Ldutt954OxYk0PZxdACvmukrlzZFuI8vg=";
  };
in
{
  home.packages = [
    profileSwitcherPackage
  ];
}
